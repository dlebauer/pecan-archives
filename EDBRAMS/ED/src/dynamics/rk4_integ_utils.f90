!==========================================================================================!
!==========================================================================================!
! Subroutine odeint                                                                        !
!                                                                                          !
!     This subroutine will drive the integration of several ODEs that drive the fast-scale !
! state variables.                                                                         !
!------------------------------------------------------------------------------------------!
subroutine odeint(h1,csite,ipa,nsteps)

   use ed_state_vars  , only : sitetype               & ! structure
                             , patchtype              & ! structure
                             , polygontype
   use rk4_coms       , only : integration_vars       & ! structure
                             , integration_buff       & ! intent(inout)
                             , rk4site                & ! intent(in)
                             , rk4min_sfcwater_mass   & ! intent(in)
                             , maxstp                 & ! intent(in)
                             , tbeg                   & ! intent(in)
                             , tend                   & ! intent(in)
                             , dtrk4                  & ! intent(in)
                             , dtrk4i                 & ! intent(in)
                             , tiny_offset            & ! intent(in)
                             , checkbudget            ! ! intent(in)
   use rk4_stepper    , only : rkqs                   ! ! subroutine
   use ed_misc_coms   , only : fast_diagnostics       ! ! intent(in)
   use hydrology_coms , only : useRUNOFF              ! ! intent(in)
   use grid_coms      , only : nzg                    ! ! intent(in)
   use soil_coms      , only : dslz8                  & ! intent(in)
                             , runoff_time            ! ! intent(in)
   use consts_coms    , only : cliq8                  & ! intent(in)
                             , t3ple8                 & ! intent(in)
                             , tsupercool8            & ! intent(in)
                             , wdnsi8                 ! ! intent(in)
   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   type(sitetype)            , target      :: csite            ! Current site
   integer                   , intent(in)  :: ipa              ! Current patch ID
   real(kind=8)              , intent(in)  :: h1               ! First guess of delta-t
   integer                   , intent(out) :: nsteps           ! Number of steps taken.
   !----- Local variables -----------------------------------------------------------------!
   type(patchtype)           , pointer     :: cpatch           ! Current patch
   integer                                 :: i                ! Step counter
   integer                                 :: ksn              ! # of snow/water layers
   real(kind=8)                            :: x                ! Elapsed time
   real(kind=8)                            :: h                ! Current delta-t attempt
   real(kind=8)                            :: hnext            ! Next delta-t
   real(kind=8)                            :: hdid             ! delta-t that worked (???)
   real(kind=8)                            :: qwfree           ! Free water internal energy
   real(kind=8)                            :: wfreeb           ! Free water 
   !----- Saved variables -----------------------------------------------------------------!
   logical                   , save        :: first_time=.true.
   logical                   , save        :: simplerunoff
   real(kind=8)              , save        :: runoff_time_i
   !----- External function. --------------------------------------------------------------!
   real                      , external    :: sngloff
   !---------------------------------------------------------------------------------------!
   
   !----- Checking whether we will use runoff or not, and saving this check to save time. -!
   if (first_time) then
      simplerunoff = useRUNOFF == 0 .and. runoff_time /= 0.
      if (runoff_time /= 0.) then
         runoff_time_i = 1.d0/dble(runoff_time)
      else 
         runoff_time_i = 0.d0
      end if
      first_time   = .false.
   end if

   cpatch => csite%patch(ipa)

   !---------------------------------------------------------------------------------------!
   !    If top snow layer is too thin for computational stability, have it evolve in       !
   ! thermal equilibrium with top soil layer.                                              !
   !---------------------------------------------------------------------------------------!
   call redistribute_snow(integration_buff%initp, csite,ipa)
   call update_diagnostic_vars(integration_buff%initp,csite,ipa)



   !---------------------------------------------------------------------------------------!
   !     Create temporary patches.                                                         !
   !---------------------------------------------------------------------------------------!
   
   call copy_rk4_patch(integration_buff%initp, integration_buff%y,cpatch)


   !---------------------------------------------------------------------------------------!
   ! Set initial time and stepsize.                                                        !
   !---------------------------------------------------------------------------------------!
   x = tbeg
   h = h1
   if (dtrk4 < 0.d0) h = -h1

   !---------------------------------------------------------------------------------------!
   ! Begin timestep loop                                                                   !
   !---------------------------------------------------------------------------------------!
   timesteploop: do i=1,maxstp

      !----- Get initial derivatives ------------------------------------------------------!
      call leaf_derivs(integration_buff%y,integration_buff%dydx,csite,ipa)

      !----- Get scalings used to determine stability -------------------------------------!
      call get_yscal(integration_buff%y, integration_buff%dydx,h,integration_buff%yscal    &
                       ,cpatch)

      !----- Be sure not to overstep ------------------------------------------------------!
      if((x+h-tend)*(x+h-tbeg) > 0.d0) h=tend-x

      !----- Take the step ----------------------------------------------------------------!
      call rkqs(x,h,hdid,hnext,csite,ipa)

      !----- If the integration reached the next step, make some final adjustments --------!
      if((x-tend)*dtrk4 >= 0.d0)then

         ksn = integration_buff%y%nlev_sfcwater

         !---------------------------------------------------------------------------------!
         !   Make temporary surface liquid water disappear.  This will not happen          !
         ! immediately, but liquid water will decay with the time scale defined by         !
         ! runoff_time scale. If the time scale is too tiny, then it will be forced to be  !
         ! hdid (no reason to be faster than that).                                        !
         !---------------------------------------------------------------------------------!
         if (simplerunoff .and. ksn >= 1) then
         
            if (integration_buff%y%sfcwater_mass(ksn) > 0.d0   .and.                       &
                integration_buff%y%sfcwater_fracliq(ksn) > 1.d-1) then
               wfreeb = min(1.d0,dtrk4*runoff_time_i)                                      &
                      * integration_buff%y%sfcwater_mass(ksn)                              &
                      * (integration_buff%y%sfcwater_fracliq(ksn) - 1.d-1) / 9.d-1

               qwfree = wfreeb                                                             &
                      * cliq8 * (integration_buff%y%sfcwater_tempk(ksn) - tsupercool8 )

               integration_buff%y%sfcwater_mass(ksn) =                                     &
                                   integration_buff%y%sfcwater_mass(ksn)                   &
                                 - wfreeb

               integration_buff%y%sfcwater_depth(ksn) =                                    &
                                   integration_buff%y%sfcwater_depth(ksn)                  &
                                 - wfreeb*wdnsi8

               !----- Recompute the energy removing runoff --------------------------------!
               integration_buff%y%sfcwater_energy(ksn) =                                   &
                                     integration_buff%y%sfcwater_energy(ksn) - qwfree

               call redistribute_snow(integration_buff%y,csite,ipa)
               call update_diagnostic_vars(integration_buff%y,csite,ipa)

               !----- Compute runoff for output -------------------------------------------!
               if (fast_diagnostics) then
                  csite%runoff(ipa) = csite%runoff(ipa)                                    &
                                    + sngloff(wfreeb * dtrk4i,tiny_offset)
                  csite%avg_runoff(ipa) = csite%avg_runoff(ipa)                            &
                                        + sngloff(wfreeb * dtrk4i,tiny_offset)
                  csite%avg_runoff_heat(ipa) = csite%avg_runoff_heat(ipa)                  &
                                             + sngloff(qwfree * dtrk4i,tiny_offset)
               end if
               if (checkbudget) then
                  integration_buff%initp%wbudget_loss2runoff = wfreeb
                  integration_buff%initp%ebudget_loss2runoff = qwfree
                  integration_buff%initp%wbudget_storage =                                 &
                     integration_buff%initp%wbudget_storage - wfreeb
                  integration_buff%initp%ebudget_storage =                                 &
                     integration_buff%initp%ebudget_storage - qwfree
               end if

            else
               csite%runoff(ipa)                          = 0.0
               csite%avg_runoff(ipa)                      = 0.0
               csite%avg_runoff_heat(ipa)                 = 0.0
               integration_buff%initp%wbudget_loss2runoff = 0.d0
               integration_buff%initp%ebudget_loss2runoff = 0.d0
            end if
         else
            csite%runoff(ipa)                          = 0.0
            csite%avg_runoff(ipa)                      = 0.0
            csite%avg_runoff_heat(ipa)                 = 0.0
            integration_buff%initp%wbudget_loss2runoff = 0.d0
            integration_buff%initp%ebudget_loss2runoff = 0.d0
         end if

         !------ Copy the temporary patch to the next intermediate step -------------------!
         call copy_rk4_patch(integration_buff%y,integration_buff%initp, cpatch)
         !------ Update the substep for next time and leave -------------------------------!
         csite%htry(ipa) = sngl(hnext)

         !---------------------------------------------------------------------------------!
         !     Update the average time step.  The square of DTLSM (tend-tbeg) is needed    !
         ! because we will divide this by the time between t0 and t0+frqsum.               !
         !---------------------------------------------------------------------------------!
         csite%avg_rk4step(ipa) = csite%avg_rk4step(ipa)                                   &
                                + sngl((tend-tbeg)*(tend-tbeg))/real(i)
         nsteps = i
         return
      end if
      
      !----- Use hnext as the next substep ------------------------------------------------!
      h = hnext
   end do timesteploop

   !----- If it reached this point, that is really bad news... ----------------------------!
   print*,'Too many steps in routine odeint'
   call print_rk4patch(integration_buff%y, csite,ipa)

   return
end subroutine odeint
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine copies the meteorological variables to the Runge-Kutta buffer.  This  !
! is to ensure all variables are in double precision, so consistent with the buffer vari-  !
! ables.                                                                                   !
!------------------------------------------------------------------------------------------!
subroutine copy_met_2_rk4site(vels,atm_enthalpy,atm_theta,atm_tmp,atm_shv,atm_co2,zoff     &
                            ,exner,pcpg,qpcpg,dpcpg,prss,geoht,lsl,green_leaf_factor       &
                            ,lon,lat)
   use ed_max_dims    , only : n_pft         ! ! intent(in)
   use rk4_coms       , only : rk4site       ! ! structure
   use canopy_air_coms, only : ubmin8        ! ! intent(in)
   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   integer                  , intent(in) :: lsl
   real                     , intent(in) :: vels
   real                     , intent(in) :: atm_enthalpy
   real                     , intent(in) :: atm_theta
   real                     , intent(in) :: atm_tmp
   real                     , intent(in) :: atm_shv
   real                     , intent(in) :: atm_co2
   real                     , intent(in) :: zoff
   real                     , intent(in) :: exner
   real                     , intent(in) :: pcpg
   real                     , intent(in) :: qpcpg
   real                     , intent(in) :: dpcpg
   real                     , intent(in) :: prss
   real                     , intent(in) :: geoht
   real   , dimension(n_pft), intent(in) :: green_leaf_factor
   real                     , intent(in) :: lon
   real                     , intent(in) :: lat
   !----- Local variables. ----------------------------------------------------------------!
   integer             :: ipft
   !---------------------------------------------------------------------------------------!

   
   rk4site%lsl     = lsl
   !----- Converting to double precision. -------------------------------------------------!
   rk4site%vels                  = max(ubmin8,dble(vels))
   rk4site%atm_enthalpy          = dble(atm_enthalpy)
   rk4site%atm_theta             = dble(atm_theta   )
   rk4site%atm_tmp               = dble(atm_tmp     )
   rk4site%atm_shv               = dble(atm_shv     )
   rk4site%atm_co2               = dble(atm_co2     )
   rk4site%zoff                  = dble(zoff        )
   rk4site%atm_exner             = dble(exner       )
   rk4site%pcpg                  = dble(pcpg        )
   rk4site%qpcpg                 = dble(qpcpg       )
   rk4site%dpcpg                 = dble(dpcpg       )
   rk4site%atm_prss              = dble(prss        )
   rk4site%geoht                 = dble(geoht       )
   rk4site%lon                   = dble(lon         )
   rk4site%lat                   = dble(lat         )
   rk4site%green_leaf_factor(:)  = dble(green_leaf_factor(:))

   return
end subroutine copy_met_2_rk4site
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutines increment the derivative into the previous guess to create the new   !
! guess.                                                                                   !
!------------------------------------------------------------------------------------------!
subroutine inc_rk4_patch(rkp, inc, fac, cpatch)
   use ed_state_vars , only : sitetype           & ! structure
                            , patchtype          ! ! structure
   use rk4_coms      , only : rk4patchtype       & ! structure
                            , rk4site            & ! intent(in)
                            , checkbudget        ! ! intent(in)
   use grid_coms     , only : nzg                & ! intent(in)
                            , nzs                ! ! intent(in)
   use ed_misc_coms  , only : fast_diagnostics   ! ! intent(in)
  
   implicit none

   !----- Arguments -----------------------------------------------------------------------!
   type(rk4patchtype) , target     :: rkp    ! Temporary patch with previous state
   type(rk4patchtype) , target     :: inc    ! Temporary patch with its derivatives
   type(patchtype)    , target     :: cpatch ! Current patch (for characteristics)
   real(kind=8)       , intent(in) :: fac    ! Increment factor
   !----- Local variables -----------------------------------------------------------------!
   integer                         :: ico    ! Cohort ID
   integer                         :: k      ! Counter
   !---------------------------------------------------------------------------------------!

   rkp%can_enthalpy = rkp%can_enthalpy + fac * inc%can_enthalpy
   rkp%can_shv      = rkp%can_shv      + fac * inc%can_shv
   rkp%can_co2      = rkp%can_co2      + fac * inc%can_co2

   do k=rk4site%lsl,nzg
      rkp%soil_water(k)       = rkp%soil_water(k)  + fac * inc%soil_water(k)
      rkp%soil_energy(k)      = rkp%soil_energy(k) + fac * inc%soil_energy(k)
   end do

   do k=1,rkp%nlev_sfcwater
      rkp%sfcwater_mass(k)   = rkp%sfcwater_mass(k)   + fac * inc%sfcwater_mass(k)
      rkp%sfcwater_energy(k) = rkp%sfcwater_energy(k) + fac * inc%sfcwater_energy(k)
      rkp%sfcwater_depth(k)  = rkp%sfcwater_depth(k)  + fac * inc%sfcwater_depth(k)
   end do

   rkp%virtual_heat  = rkp%virtual_heat  + fac * inc%virtual_heat
   rkp%virtual_water = rkp%virtual_water + fac * inc%virtual_water
   rkp%virtual_depth = rkp%virtual_depth + fac * inc%virtual_depth

  
   rkp%upwp = rkp%upwp + fac * inc%upwp
   rkp%wpwp = rkp%wpwp + fac * inc%wpwp
   rkp%tpwp = rkp%tpwp + fac * inc%tpwp
   rkp%qpwp = rkp%qpwp + fac * inc%qpwp
   rkp%cpwp = rkp%cpwp + fac * inc%cpwp

  
   do ico = 1,cpatch%ncohorts
      rkp%veg_water(ico)     = rkp%veg_water(ico)  + fac * inc%veg_water(ico)
      rkp%veg_energy(ico)    = rkp%veg_energy(ico) + fac * inc%veg_energy(ico)
   end do

   if(checkbudget) then

     rkp%co2budget_storage      = rkp%co2budget_storage     + fac * inc%co2budget_storage
     rkp%co2budget_loss2atm     = rkp%co2budget_loss2atm    + fac * inc%co2budget_loss2atm

      rkp%wbudget_storage       = rkp%wbudget_storage       + fac * inc%wbudget_storage
      rkp%wbudget_loss2atm      = rkp%wbudget_loss2atm      + fac * inc%wbudget_loss2atm
      rkp%wbudget_loss2drainage = rkp%wbudget_loss2drainage                                &
                                + fac * inc%wbudget_loss2drainage

      rkp%ebudget_storage       = rkp%ebudget_storage       + fac * inc%ebudget_storage
      rkp%ebudget_loss2atm      = rkp%ebudget_loss2atm      + fac * inc%ebudget_loss2atm
      rkp%ebudget_loss2drainage = rkp%ebudget_loss2drainage                                &
                                + fac * inc%ebudget_loss2drainage
      rkp%ebudget_latent        = rkp%ebudget_latent        + fac * inc%ebudget_latent
   end if
   if (fast_diagnostics) then
      rkp%avg_carbon_ac      = rkp%avg_carbon_ac      + fac * inc%avg_carbon_ac
      
      rkp%avg_vapor_vc       = rkp%avg_vapor_vc       + fac * inc%avg_vapor_vc
      rkp%avg_dew_cg         = rkp%avg_dew_cg         + fac * inc%avg_dew_cg
      rkp%avg_vapor_gc       = rkp%avg_vapor_gc       + fac * inc%avg_vapor_gc
      rkp%avg_wshed_vg       = rkp%avg_wshed_vg       + fac * inc%avg_wshed_vg
      rkp%avg_intercepted    = rkp%avg_intercepted    + fac * inc%avg_intercepted
      rkp%avg_vapor_ac       = rkp%avg_vapor_ac       + fac * inc%avg_vapor_ac
      rkp%avg_transp         = rkp%avg_transp         + fac * inc%avg_transp
      rkp%avg_evap           = rkp%avg_evap           + fac * inc%avg_evap
      rkp%avg_drainage       = rkp%avg_drainage       + fac * inc%avg_drainage
      rkp%avg_drainage_heat  = rkp%avg_drainage_heat  + fac * inc%avg_drainage_heat
      rkp%avg_netrad         = rkp%avg_netrad         + fac * inc%avg_netrad
      rkp%avg_sensible_vc    = rkp%avg_sensible_vc    + fac * inc%avg_sensible_vc
      rkp%avg_qwshed_vg      = rkp%avg_qwshed_vg      + fac * inc%avg_qwshed_vg
      rkp%avg_qintercepted   = rkp%avg_qintercepted   + fac * inc%avg_qintercepted
      rkp%avg_sensible_gc    = rkp%avg_sensible_gc    + fac * inc%avg_sensible_gc
      rkp%avg_sensible_ac    = rkp%avg_sensible_ac    + fac * inc%avg_sensible_ac

      do k=rk4site%lsl,nzg
         rkp%avg_sensible_gg(k)  = rkp%avg_sensible_gg(k)  + fac * inc%avg_sensible_gg(k)
         rkp%avg_smoist_gg(k)    = rkp%avg_smoist_gg(k)    + fac * inc%avg_smoist_gg(k)  
         rkp%avg_smoist_gc(k)    = rkp%avg_smoist_gc(k)    + fac * inc%avg_smoist_gc(k)  
      end do

   end if

   return
end subroutine inc_rk4_patch
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine finds the error scale for the integrated variables, which will be     !
! later used to define the relative error.                                                 !
!------------------------------------------------------------------------------------------!
subroutine get_yscal(y,dy,htry,yscal,cpatch)
   use ed_state_vars        , only : patchtype            ! ! structure
   use rk4_coms             , only : rk4patchtype         & ! structure
                                   , rk4site              & ! intent(in)
                                   , tiny_offset          & ! intent(in)
                                   , huge_offset          & ! intent(in)
                                   , rk4water_stab_thresh & ! intent(in)
                                   , rk4min_sfcwater_mass & ! intent(in)
                                   , rk4dry_veg_lwater    & ! intent(in)
                                   , checkbudget          ! ! intent(in)
   use grid_coms            , only : nzg                  & ! intent(in)
                                   , nzs                  ! ! intent(in)
   use consts_coms          , only : cliq8                & ! intent(in)
                                   , qliqt38              ! ! intent(in)
   use soil_coms            , only : isoilbc              ! ! intent(in)
   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   type(rk4patchtype), target     :: y                     ! Struct. with the guesses
   type(rk4patchtype), target     :: dy                    ! Struct. with their derivatives
   type(rk4patchtype), target     :: yscal                 ! Struct. with their scales
   type(patchtype)   , target     :: cpatch                ! Current patch
   real(kind=8)      , intent(in) :: htry                  ! Time-step we are trying
   !----- Local variables -----------------------------------------------------------------!
   real(kind=8)                   :: tot_sfcw_mass         ! Total surface water/snow mass
   real(kind=8)                   :: meanscale_sfcw_mass   ! Average Sfc. water mass scale
   real(kind=8)                   :: meanscale_sfcw_energy ! Average Sfc. water en. scale
   real(kind=8)                   :: meanscale_sfcw_depth  ! Average Sfc. water depth scale
   integer                        :: k                     ! Counter
   integer                        :: ico                   ! Current cohort ID
   !---------------------------------------------------------------------------------------!

   yscal%can_enthalpy = abs(y%can_enthalpy) + abs(dy%can_enthalpy * htry) + tiny_offset
   yscal%can_shv      = abs(y%can_shv     ) + abs(dy%can_shv      * htry) + tiny_offset
   yscal%can_co2      = abs(y%can_co2     ) + abs(dy%can_co2      * htry) + tiny_offset

   yscal%upwp = max(abs(y%upwp) + abs(dy%upwp*htry),1.d0)
   yscal%wpwp = max(abs(y%wpwp) + abs(dy%wpwp*htry),1.d0)


  
   do k=rk4site%lsl,nzg
      yscal%soil_water(k)  = abs(y%soil_water(k))  + abs(dy%soil_water(k)*htry)            &
                           + tiny_offset
      yscal%soil_energy(k) = abs(y%soil_energy(k)) + abs(dy%soil_energy(k)*htry)           &
                           + tiny_offset
   end do

   tot_sfcw_mass = 0.d0
   do k=1,y%nlev_sfcwater
      tot_sfcw_mass = tot_sfcw_mass + y%sfcwater_mass(k)
   end do
   tot_sfcw_mass = abs(tot_sfcw_mass)
   
   
   !---------------------------------------------------------------------------------------!
   !     Temporary surface layers require a special approach. The number of layers may     !
   ! vary during the integration process, so we must make sure that all layers initially   !
   ! have a scale.  Also, if the total mass is small, we must be more tolerant to avoid    !
   ! overestimating the error because of the small size.                                   !
   !---------------------------------------------------------------------------------------!
   if (tot_sfcw_mass > 1.d-2*rk4water_stab_thresh) then
      !----- Computationally stable layer. ------------------------------------------------!
      meanscale_sfcw_mass   = 0.d0
      meanscale_sfcw_energy = 0.d0
      meanscale_sfcw_depth  = 0.d0
      do k=1,y%nlev_sfcwater
         yscal%sfcwater_mass(k)   = abs(y%sfcwater_mass(k))                                &
                                  + abs(dy%sfcwater_mass(k)*htry)
         yscal%sfcwater_energy(k) = abs(y%sfcwater_energy(k))                              &
                                  + abs(dy%sfcwater_energy(k)*htry)
         yscal%sfcwater_depth(k)  = abs(y%sfcwater_depth(k))                               &
                                  + abs(dy%sfcwater_depth(k)*htry)

         meanscale_sfcw_mass   = meanscale_sfcw_mass   + yscal%sfcwater_mass(k)
         meanscale_sfcw_energy = meanscale_sfcw_energy + yscal%sfcwater_energy(k)
         meanscale_sfcw_depth  = meanscale_sfcw_depth  + yscal%sfcwater_depth(k)
      end do
      !----- Update average (this is safe because here there is at least one layer. -------!
      meanscale_sfcw_mass   = meanscale_sfcw_mass   / real(y%nlev_sfcwater)
      meanscale_sfcw_energy = meanscale_sfcw_energy / real(y%nlev_sfcwater)
      meanscale_sfcw_depth  = meanscale_sfcw_depth  / real(y%nlev_sfcwater)

      do k=y%nlev_sfcwater+1,nzs
         yscal%sfcwater_mass(k)   = meanscale_sfcw_mass
         yscal%sfcwater_energy(k) = meanscale_sfcw_energy
         yscal%sfcwater_depth(k)  = meanscale_sfcw_depth
      end do
   else
      !----- Low stability threshold ------------------------------------------------------!
      do k=1,nzs
         if(abs(y%sfcwater_mass(k)) > rk4min_sfcwater_mass)then
            yscal%sfcwater_mass(k) = 1.d-2*rk4water_stab_thresh
            yscal%sfcwater_energy(k) = ( yscal%sfcwater_mass(k) / abs(y%sfcwater_mass(k))) &
                                     * ( abs( y%sfcwater_energy(k))                        &
                                       + abs(dy%sfcwater_energy(k)*htry))
            yscal%sfcwater_depth(k)  = ( yscal%sfcwater_mass(k) / abs(y%sfcwater_mass(k))) &
                                     * abs(y%sfcwater_depth(k))                            &
                                     + abs(dy%sfcwater_depth(k)*htry)
         else
            yscal%sfcwater_mass(k)   = huge_offset
            yscal%sfcwater_energy(k) = huge_offset
            yscal%sfcwater_depth(k)  = huge_offset
         end if
      end do
   end if

   !----- Scale for the virtual water pools -----------------------------------------------!
   if (abs(y%virtual_water) > 1.d-2*rk4water_stab_thresh) then
      yscal%virtual_water = abs(y%virtual_water) + abs(dy%virtual_water*htry)
      yscal%virtual_heat  = abs(y%virtual_heat) + abs(dy%virtual_heat*htry)
   elseif (abs(y%virtual_water) > rk4min_sfcwater_mass) then
      yscal%virtual_water = 1.d-2*rk4water_stab_thresh
      yscal%virtual_heat  = (yscal%virtual_water / abs(y%virtual_water))                   &
                          * (abs(y%virtual_heat) + abs(dy%virtual_heat*htry))
   else
      yscal%virtual_water = huge_offset
      yscal%virtual_heat  = huge_offset
   end if

   !---------------------------------------------------------------------------------------!
   !    Scale for leaf water and energy. In case the plants have few or no leaves, or the  !
   ! plant is buried in snow, we assign huge values for typical scale, thus preventing     !
   ! unecessary small steps.                                                               !
   !    Also, if the cohort is tiny and has almost no water, make the scale less strict.   !
   !---------------------------------------------------------------------------------------!
   do ico = 1,cpatch%ncohorts
      if (.not. y%solvable(ico)) then
         yscal%solvable(ico)   = .false.
         yscal%veg_water(ico)  = huge_offset
         yscal%veg_energy(ico) = huge_offset
      elseif (y%veg_water(ico) > rk4dry_veg_lwater*y%tai(ico)) then
         yscal%solvable(ico)   = .true.
         yscal%veg_water(ico)  = abs(y%veg_water(ico))  + abs(dy%veg_water(ico)  * htry)
         yscal%veg_energy(ico) = abs(y%veg_energy(ico)) + abs(dy%veg_energy(ico) * htry)
      else
         yscal%solvable(ico)   = .true.
         yscal%veg_water(ico)  = rk4dry_veg_lwater*y%tai(ico)
         yscal%veg_energy(ico) = max(yscal%veg_water(ico)*qliqt38                          &
                                    ,abs(y%veg_energy(ico)) + abs(dy%veg_energy(ico)*htry))
      end if
   end do

   !-------------------------------------------------------------------------!
   !     Here we just need to make sure the user is checking mass, otherwise !
   ! these variables will not be computed at all.  If this turns out to be   !
   ! essential, we will make this permanent and not dependent on             !
   ! checkbudget.  The only one that is not checked is the runoff, because   !
   ! it is computed after a step was accepted.                               !
   !-------------------------------------------------------------------------!
   if (checkbudget) then
      !----------------------------------------------------------------------!
      !    If this is the very first time step, or if we are misfortuned, we !
      ! may have a situation in which the derivative is numerically zero,    !
      ! and making the check will become impossible because the scale would  !
      ! be ridiculously tiny, so we skip the check this time and hope that   !
      ! everything will be alright next step.                                !
      !----------------------------------------------------------------------!
      if (abs(y%co2budget_loss2atm)  < tiny_offset .and.                     &
          abs(dy%co2budget_loss2atm) < tiny_offset) then
         yscal%co2budget_loss2atm = 1.d-1
      else 
         yscal%co2budget_loss2atm = abs(y%co2budget_loss2atm)                &
                                  + abs(dy%co2budget_loss2atm*htry)
         yscal%co2budget_loss2atm = max(yscal%co2budget_loss2atm,1.d-1)
      end if

      if (abs(y%ebudget_loss2atm)  < tiny_offset .and.                       &
          abs(dy%ebudget_loss2atm) < tiny_offset) then
         yscal%ebudget_loss2atm = 1.d0
      else 
         yscal%ebudget_loss2atm = abs(y%ebudget_loss2atm)                    &
                                + abs(dy%ebudget_loss2atm*htry)
         yscal%ebudget_loss2atm = max(yscal%ebudget_loss2atm,1.d0)
      end if

      if (abs(y%wbudget_loss2atm)  < tiny_offset .and.                       &
          abs(dy%wbudget_loss2atm) < tiny_offset) then
         yscal%wbudget_loss2atm      = 1.d-6
      else 
         yscal%wbudget_loss2atm = abs(y%wbudget_loss2atm)                    &
                                + abs(dy%wbudget_loss2atm*htry)
         yscal%wbudget_loss2atm = max(yscal%wbudget_loss2atm,1.d-6)
      end if

      if (abs(y%ebudget_latent)  < tiny_offset .and.                         &
          abs(dy%ebudget_latent) < tiny_offset) then
         yscal%ebudget_latent      = 1.d0
      else 
         yscal%ebudget_latent = abs(y%ebudget_latent)                        &
                              + abs(dy%ebudget_latent*htry)
         yscal%ebudget_latent = max(yscal%ebudget_latent,1.d0)
      end if

      if (abs(y%ebudget_storage)  < tiny_offset .and.                        &
          abs(dy%ebudget_storage) < tiny_offset) then
         yscal%ebudget_storage = huge_offset
      else 
         yscal%ebudget_storage = abs(y%ebudget_storage)                      &
                                + abs(dy%ebudget_storage*htry)
      end if

      if (abs(y%co2budget_storage)  < tiny_offset .and.                      &
          abs(dy%co2budget_storage) < tiny_offset) then
         yscal%co2budget_storage = huge_offset
      else 
         yscal%co2budget_storage = abs(y%co2budget_storage)                  &
                                + abs(dy%co2budget_storage*htry)
      end if

      if (abs(y%wbudget_storage)  < tiny_offset .and.                        &
          abs(dy%wbudget_storage) < tiny_offset) then
         yscal%wbudget_storage      = huge_offset
      else 
         yscal%wbudget_storage = abs(y%wbudget_storage)                      &
                               + abs(dy%wbudget_storage*htry)
      end if

      !----------------------------------------------------------------------!
      !     Drainage terms will be checked only if the boundary condition is !
      ! free drainage.                                                       !
      !----------------------------------------------------------------------!
      if (isoilbc == 0                                .or.                   &
          (abs(y%ebudget_loss2drainage)  < tiny_offset .and.                 &
           abs(dy%ebudget_loss2drainage) < tiny_offset)      ) then
         yscal%ebudget_loss2drainage = huge_offset
      else 
         yscal%ebudget_loss2drainage = abs(y%ebudget_loss2drainage)          &
                                     + abs(dy%ebudget_loss2drainage*htry)
      end if
      if (isoilbc == 0                                .or.                   &
          (abs(y%wbudget_loss2drainage)  < tiny_offset .and.                 &
           abs(dy%wbudget_loss2drainage) < tiny_offset)      ) then
         yscal%wbudget_loss2drainage = huge_offset
      else 
         yscal%wbudget_loss2drainage = abs(y%wbudget_loss2drainage)          &
                                     + abs(dy%wbudget_loss2drainage*htry)
      end if

   else 
      yscal%co2budget_storage       = huge_offset
      yscal%co2budget_loss2atm      = huge_offset
      yscal%ebudget_loss2atm        = huge_offset
      yscal%wbudget_loss2atm        = huge_offset
      yscal%ebudget_storage         = huge_offset
      yscal%wbudget_storage         = huge_offset
      yscal%ebudget_latent          = huge_offset
      yscal%ebudget_loss2drainage   = huge_offset
      yscal%wbudget_loss2drainage   = huge_offset
   end if

   return
end subroutine get_yscal
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine loops through the integrating variables, seeking for the largest      !
! error.                                                                                   !
!------------------------------------------------------------------------------------------!
subroutine get_errmax(errmax,yerr,yscal,cpatch,y,ytemp)

   use rk4_coms              , only : rk4patchtype       & ! structure
                                    , rk4eps             & ! intent(in)
                                    , rk4site            & ! intent(in)
                                    , checkbudget        ! ! intent(in)
   use ed_state_vars         , only : patchtype          ! ! structure
   use grid_coms             , only : nzg                ! ! intent(in)
   use ed_misc_coms          , only : integ_err          & ! intent(in)
                                    , record_err         ! ! intent(in)
   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   type(rk4patchtype) , target      :: yerr             ! Error structure
   type(rk4patchtype) , target      :: yscal            ! Scale structure
   type(rk4patchtype) , target      :: y                ! Structure with previous value
   type(rk4patchtype) , target      :: ytemp            ! Structure with attempted values
   type(patchtype)    , target      :: cpatch           ! Current patch
   real(kind=8)       , intent(out) :: errmax           ! Maximum error
   !----- Local variables -----------------------------------------------------------------!
   integer                          :: ico              ! Current cohort ID
   real(kind=8)                     :: errh2o           ! Scratch error variable
   real(kind=8)                     :: errene           ! Scratch error variable
   real(kind=8)                     :: err              ! Scratch error variable
   real(kind=8)                     :: errh2oMAX        ! Scratch error variable
   real(kind=8)                     :: erreneMAX        ! Scratch error variable
   integer                          :: k                ! Counter
   !---------------------------------------------------------------------------------------!

   !----- Initialize error ----------------------------------------------------------------!
   errmax = 0.d0

   !---------------------------------------------------------------------------------------!
   !    We know check each variable error, and keep track of the worst guess, which will   !
   ! be our worst guess in the end.                                                        !
   !---------------------------------------------------------------------------------------!

   err    = abs(yerr%can_enthalpy/yscal%can_enthalpy)
   errmax = max(errmax,err)
   if(record_err .and. err > rk4eps) integ_err(1,1) = integ_err(1,1) + 1_8 

   err    = abs(yerr%can_shv/yscal%can_shv)
   errmax = max(errmax,err)
   if(record_err .and. err > rk4eps) integ_err(2,1) = integ_err(2,1) + 1_8 

   err    = abs(yerr%can_co2/yscal%can_co2)
   errmax = max(errmax,err)
   if(record_err .and. err > rk4eps) integ_err(3,1) = integ_err(3,1) + 1_8 
  
   do k=rk4site%lsl,nzg
      err    = abs(yerr%soil_water(k)/yscal%soil_water(k))
      errmax = max(errmax,err)
      if(record_err .and. err > rk4eps) integ_err(3+k,1) = integ_err(3+k,1) + 1_8 
   end do

   do k=rk4site%lsl,nzg
      err    = abs(yerr%soil_energy(k)/yscal%soil_energy(k))
      errmax = max(errmax,err)
      if(record_err .and. err > rk4eps) integ_err(15+k,1) = integ_err(15+k,1) + 1_8
   end do

   do k=1,ytemp%nlev_sfcwater
      err = abs(yerr%sfcwater_energy(k) / yscal%sfcwater_energy(k))
      errmax = max(errmax,err)
      if(record_err .and. err > rk4eps) integ_err(27+k,1) = integ_err(27+k,1) + 1_8
   end do

   do k=1,ytemp%nlev_sfcwater
      err    = abs(yerr%sfcwater_mass(k) / yscal%sfcwater_mass(k))
      errmax = max(errmax,err)
      if(record_err .and. err > rk4eps) integ_err(32+k,1) = integ_err(32+k,1) + 1_8
   end do

   err    = abs(yerr%virtual_heat/yscal%virtual_heat)
   errmax = max(errmax,err)
   if(record_err .and. err > rk4eps) integ_err(38,1) = integ_err(38,1) + 1_8

   err    = abs(yerr%virtual_water/yscal%virtual_water)
   errmax = max(errmax,err)
   if(record_err .and. err > rk4eps) integ_err(39,1) = integ_err(39,1) + 1_8      

   !---------------------------------------------------------------------------------------!
   !     Getting the worst error only amongst the cohorts in which leaf properties were    !
   ! computed.                                                                             !
   !---------------------------------------------------------------------------------------!
   do ico = 1,cpatch%ncohorts
      errh2oMAX = 0.d0
      erreneMAX = 0.d0
      if (yscal%solvable(ico)) then
         errh2o     = abs(yerr%veg_water(ico)  / yscal%veg_water(ico))
         errene     = abs(yerr%veg_energy(ico) / yscal%veg_energy(ico))
         errmax     = max(errmax,errh2o,errene)
         errh2oMAX  = max(errh2oMAX,errh2o)
         erreneMAX  = max(erreneMAX,errene)
      end if
   end do
   if(cpatch%ncohorts > 0 .and. record_err) then
      if (errh2oMAX > rk4eps) integ_err(40,1) = integ_err(40,1) + 1_8
      if (erreneMAX > rk4eps) integ_err(41,1) = integ_err(41,1) + 1_8
   end if

   !-------------------------------------------------------------------------!
   !     Here we just need to make sure the user is checking mass, otherwise !
   ! these variables will not be computed at all.  If this turns out to be   !
   ! essential, we will make this permanent and not dependent on             !
   ! checkbudget.  The only one that is not checked is the runoff, because   !
   ! it is computed after a step was accepted.                               !
   !-------------------------------------------------------------------------!
   if (checkbudget) then
      err    = abs(yerr%co2budget_storage/yscal%co2budget_storage)
      errmax = max(errmax,err)
      err    = abs(yerr%co2budget_loss2atm/yscal%co2budget_loss2atm)
      errmax = max(errmax,err)
      err    = abs(yerr%ebudget_loss2atm/yscal%ebudget_loss2atm)
      errmax = max(errmax,err)
      err    = abs(yerr%wbudget_loss2atm/yscal%wbudget_loss2atm)
      errmax = max(errmax,err)
      err    = abs(yerr%ebudget_latent/yscal%ebudget_latent)
      errmax = max(errmax,err)
      err    = abs(yerr%ebudget_loss2drainage/yscal%ebudget_loss2drainage)
      errmax = max(errmax,err)
      err    = abs(yerr%wbudget_loss2drainage/yscal%wbudget_loss2drainage)
      errmax = max(errmax,err)
      err    = abs(yerr%ebudget_storage/yscal%ebudget_storage)
      errmax = max(errmax,err)
      err    = abs(yerr%wbudget_storage/yscal%wbudget_storage)
      errmax = max(errmax,err)
   end if

   return
end subroutine get_errmax
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine copies the values to different buffers inside the RK4 integration     !
! scheme.                                                                                  !
!------------------------------------------------------------------------------------------!
subroutine copy_rk4_patch(sourcep, targetp, cpatch)

   use rk4_coms      , only : rk4site           & ! intent(in)
                            , rk4patchtype      & ! structure
                            , checkbudget       ! ! intent(in)
   use ed_state_vars , only : sitetype          & ! structure
                            , patchtype         ! ! structure
   use grid_coms     , only : nzg               & ! intent(in)
                            , nzs               ! ! intent(in)
   use ed_max_dims      , only : n_pft             ! ! intent(in)
   use ed_misc_coms  , only : fast_diagnostics  ! ! intent(in)

   implicit none
   !----- Arguments -----------------------------------------------------------------------!
   type(rk4patchtype) , target     :: sourcep
   type(rk4patchtype) , target     :: targetp
   type(patchtype)    , target     :: cpatch
   !----- Local variable ------------------------------------------------------------------!
   integer                         :: k
   !---------------------------------------------------------------------------------------!

   targetp%can_enthalpy  = sourcep%can_enthalpy
   targetp%can_theta     = sourcep%can_theta
   targetp%can_temp      = sourcep%can_temp
   targetp%can_shv       = sourcep%can_shv
   targetp%can_co2       = sourcep%can_co2
   targetp%can_rhos      = sourcep%can_rhos
   targetp%can_prss      = sourcep%can_prss
   targetp%can_depth     = sourcep%can_depth

   targetp%virtual_water = sourcep%virtual_water
   targetp%virtual_heat  = sourcep%virtual_heat
   targetp%virtual_depth = sourcep%virtual_depth

   targetp%rough         = sourcep%rough
 
   targetp%upwp          = sourcep%upwp
   targetp%wpwp          = sourcep%wpwp
   targetp%tpwp          = sourcep%tpwp
   targetp%qpwp          = sourcep%qpwp
   targetp%cpwp          = sourcep%cpwp

   targetp%ground_shv    = sourcep%ground_shv
   targetp%surface_ssh   = sourcep%surface_ssh
   targetp%surface_temp  = sourcep%surface_temp
   targetp%surface_fliq  = sourcep%surface_fliq

   targetp%nlev_sfcwater = sourcep%nlev_sfcwater
   targetp%ustar         = sourcep%ustar
   targetp%cstar         = sourcep%cstar
   targetp%tstar         = sourcep%tstar
   targetp%estar         = sourcep%estar
   targetp%qstar         = sourcep%qstar
   targetp%virtual_flag  = sourcep%virtual_flag
   targetp%rasveg        = sourcep%rasveg

   targetp%cwd_rh        = sourcep%cwd_rh
   targetp%rh            = sourcep%rh

   do k=rk4site%lsl,nzg
      
      targetp%soil_water            (k) = sourcep%soil_water            (k)
      targetp%soil_energy           (k) = sourcep%soil_energy           (k)
      targetp%soil_tempk            (k) = sourcep%soil_tempk            (k)
      targetp%soil_fracliq          (k) = sourcep%soil_fracliq          (k)
      targetp%available_liquid_water(k) = sourcep%available_liquid_water(k)
      targetp%extracted_water       (k) = sourcep%extracted_water       (k)
      targetp%psiplusz              (k) = sourcep%psiplusz              (k)
      targetp%soilair99             (k) = sourcep%soilair99             (k)
      targetp%soilair01             (k) = sourcep%soilair01             (k)
      targetp%soil_liq              (k) = sourcep%soil_liq              (k)
   end do

   do k=1,nzs
      targetp%sfcwater_mass   (k) = sourcep%sfcwater_mass   (k)
      targetp%sfcwater_energy (k) = sourcep%sfcwater_energy (k)
      targetp%sfcwater_depth  (k) = sourcep%sfcwater_depth  (k)
      targetp%sfcwater_tempk  (k) = sourcep%sfcwater_tempk  (k)
      targetp%sfcwater_fracliq(k) = sourcep%sfcwater_fracliq(k)
   end do

   do k=1,cpatch%ncohorts
      targetp%veg_water   (k) = sourcep%veg_water   (k)
      targetp%veg_energy  (k) = sourcep%veg_energy  (k)
      targetp%veg_temp    (k) = sourcep%veg_temp    (k)
      targetp%veg_fliq    (k) = sourcep%veg_fliq    (k)
      targetp%hcapveg     (k) = sourcep%hcapveg     (k)
      targetp%nplant      (k) = sourcep%nplant      (k)
      targetp%lai         (k) = sourcep%lai         (k)
      targetp%wai         (k) = sourcep%wai         (k)
      targetp%wpa         (k) = sourcep%wpa         (k)
      targetp%tai         (k) = sourcep%tai         (k)
      targetp%solvable    (k) = sourcep%solvable    (k)
      targetp%rb          (k) = sourcep%rb          (k)
      targetp%gpp         (k) = sourcep%gpp         (k)
      targetp%leaf_resp   (k) = sourcep%leaf_resp   (k)
      targetp%root_resp   (k) = sourcep%root_resp   (k)
      targetp%growth_resp (k) = sourcep%growth_resp (k)
      targetp%storage_resp(k) = sourcep%storage_resp(k)
      targetp%vleaf_resp  (k) = sourcep%vleaf_resp  (k)
   end do

   if (checkbudget) then
      targetp%co2budget_storage      = sourcep%co2budget_storage
      targetp%co2budget_loss2atm     = sourcep%co2budget_loss2atm
      targetp%ebudget_loss2atm       = sourcep%ebudget_loss2atm
      targetp%ebudget_loss2drainage  = sourcep%ebudget_loss2drainage
      targetp%ebudget_loss2runoff    = sourcep%ebudget_loss2runoff
      targetp%ebudget_latent         = sourcep%ebudget_latent
      targetp%wbudget_loss2atm       = sourcep%wbudget_loss2atm
      targetp%wbudget_loss2drainage  = sourcep%wbudget_loss2drainage
      targetp%wbudget_loss2runoff    = sourcep%wbudget_loss2runoff
      targetp%ebudget_storage        = sourcep%ebudget_storage
      targetp%wbudget_storage        = sourcep%wbudget_storage
   end if
   if (fast_diagnostics) then
      targetp%avg_carbon_ac          = sourcep%avg_carbon_ac
      targetp%avg_vapor_vc           = sourcep%avg_vapor_vc
      targetp%avg_dew_cg             = sourcep%avg_dew_cg  
      targetp%avg_vapor_gc           = sourcep%avg_vapor_gc
      targetp%avg_wshed_vg           = sourcep%avg_wshed_vg
      targetp%avg_intercepted        = sourcep%avg_intercepted
      targetp%avg_vapor_ac           = sourcep%avg_vapor_ac
      targetp%avg_transp             = sourcep%avg_transp  
      targetp%avg_evap               = sourcep%avg_evap   
      targetp%avg_netrad             = sourcep%avg_netrad   
      targetp%avg_sensible_vc        = sourcep%avg_sensible_vc  
      targetp%avg_qwshed_vg          = sourcep%avg_qwshed_vg    
      targetp%avg_qintercepted       = sourcep%avg_qintercepted
      targetp%avg_sensible_gc        = sourcep%avg_sensible_gc  
      targetp%avg_sensible_ac        = sourcep%avg_sensible_ac
      targetp%avg_drainage           = sourcep%avg_drainage
      targetp%avg_drainage_heat      = sourcep%avg_drainage_heat

      do k=rk4site%lsl,nzg
         targetp%avg_sensible_gg(k) = sourcep%avg_sensible_gg(k)
         targetp%avg_smoist_gg(k)   = sourcep%avg_smoist_gg(k)  
         targetp%avg_smoist_gc(k)   = sourcep%avg_smoist_gc(k)  
      end do
   end if



   return
end subroutine copy_rk4_patch
!==========================================================================================!
!==========================================================================================!






!==========================================================================================!
!==========================================================================================!
!    This subroutine will perform the allocation for the Runge-Kutta integrator structure, !
! and initialize it as well.                                                               !
!------------------------------------------------------------------------------------------!
subroutine initialize_rk4patches(init)

   use ed_state_vars , only : edgrid_g              & ! intent(inout)
                            , edtype                & ! structure
                            , polygontype           & ! structure
                            , sitetype              & ! structure
                            , patchtype             ! ! structure
   use rk4_coms      , only : integration_buff      & ! structure
                            , deallocate_rk4_coh & ! structure
                            , allocate_rk4_patch    & ! structure
                            , allocate_rk4_coh   ! ! structure
   use grid_coms     , only : ngrids                ! ! intent(in)
   implicit none
   !----- Argument ------------------------------------------------------------------------!
   integer           , intent(in) :: init
   !----- Local variables -----------------------------------------------------------------!
   type(edtype)      , pointer    :: cgrid
   type(polygontype) , pointer    :: cpoly
   type(sitetype)    , pointer    :: csite
   type(patchtype)   , pointer    :: cpatch
   integer                        :: maxcohort
   integer                        :: igr
   integer                        :: ipy
   integer                        :: isi
   integer                        :: ipa
   !---------------------------------------------------------------------------------------!

   if (init == 0) then
      !------------------------------------------------------------------------------------!
      !    If this is not initialization, deallocate cohort memory from integration        !
      ! patches.                                                                           !
      !------------------------------------------------------------------------------------!
      call deallocate_rk4_coh(integration_buff%initp)
      call deallocate_rk4_coh(integration_buff%yscal)
      call deallocate_rk4_coh(integration_buff%y)
      call deallocate_rk4_coh(integration_buff%dydx)
      call deallocate_rk4_coh(integration_buff%yerr)
      call deallocate_rk4_coh(integration_buff%ytemp)
      call deallocate_rk4_coh(integration_buff%ak2)
      call deallocate_rk4_coh(integration_buff%ak3)
      call deallocate_rk4_coh(integration_buff%ak4)
      call deallocate_rk4_coh(integration_buff%ak5)
      call deallocate_rk4_coh(integration_buff%ak6)
      call deallocate_rk4_coh(integration_buff%ak7)
   else
      !------------------------------------------------------------------------------------!
      !     If this is initialization, make sure soil and sfcwater arrays are allocated.   !
      !------------------------------------------------------------------------------------!
      call allocate_rk4_patch(integration_buff%initp)
      call allocate_rk4_patch(integration_buff%yscal)
      call allocate_rk4_patch(integration_buff%y)
      call allocate_rk4_patch(integration_buff%dydx)
      call allocate_rk4_patch(integration_buff%yerr)
      call allocate_rk4_patch(integration_buff%ytemp)
      call allocate_rk4_patch(integration_buff%ak2)
      call allocate_rk4_patch(integration_buff%ak3)
      call allocate_rk4_patch(integration_buff%ak4)
      call allocate_rk4_patch(integration_buff%ak5)
      call allocate_rk4_patch(integration_buff%ak6)
      call allocate_rk4_patch(integration_buff%ak7)
   end if

   !----- Find maximum number of cohorts amongst all patches ------------------------------!
   maxcohort = 1
   do igr = 1,ngrids
      cgrid => edgrid_g(igr)
      do ipy = 1,cgrid%npolygons
         cpoly => cgrid%polygon(ipy)
         do isi = 1,cpoly%nsites
            csite => cpoly%site(isi)
            do ipa = 1,csite%npatches
               cpatch => csite%patch(ipa)
               maxcohort = max(maxcohort,cpatch%ncohorts)
            end do
         end do
      end do
   end do
   ! write (unit=*,fmt='(a,1x,i5)') 'Maxcohort = ',maxcohort

   !----- Create new memory in each of the integration patches. ---------------------------!
   call allocate_rk4_coh(maxcohort,integration_buff%initp)
   call allocate_rk4_coh(maxcohort,integration_buff%yscal)
   call allocate_rk4_coh(maxcohort,integration_buff%y)
   call allocate_rk4_coh(maxcohort,integration_buff%dydx)
   call allocate_rk4_coh(maxcohort,integration_buff%yerr)
   call allocate_rk4_coh(maxcohort,integration_buff%ytemp)
   call allocate_rk4_coh(maxcohort,integration_buff%ak2)
   call allocate_rk4_coh(maxcohort,integration_buff%ak3)
   call allocate_rk4_coh(maxcohort,integration_buff%ak4)
   call allocate_rk4_coh(maxcohort,integration_buff%ak5)
   call allocate_rk4_coh(maxcohort,integration_buff%ak6)
   call allocate_rk4_coh(maxcohort,integration_buff%ak7)
  
   return
end subroutine initialize_rk4patches
!==========================================================================================!
!==========================================================================================!

