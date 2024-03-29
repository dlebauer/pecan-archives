!==========================================================================================!
!==========================================================================================!
!     Some constants, happening mostly at rk4_derivs.f90.  These used to be at ed_commons, !
! moved it here so they stay together. Still need some explanation of what these variables !
! represent.                                                                               !
!------------------------------------------------------------------------------------------!
module canopy_air_coms

   use consts_coms, only : twothirds & ! intent(in)
                         , vonk      ! ! intent(in)

   !=======================================================================================!
   !=======================================================================================!
   !     Parameter that will be read in the namelist.                                      !
   !---------------------------------------------------------------------------------------!
   integer :: icanturb ! Which canopy turbulence we will use?
                       ! -1. is the original ED-2.0 scheme
                       !  0. is the default scheme
                       !  1. will rescale reference wind-speed if it
                       !     the reference height is (inapropriately)
                       !     below the canopy
                       !  2. (recommended) uses the method of Massman 
                       !     1997 and the bulk Richardson number of 
                       !     instability.  This method will not work 
                       !     when zref<h
   integer :: isfclyrm ! Surface layer model (used to compute ustar, tstar,...)
                       !  1 - Louis, 1979: Boundary-Layer Meteor., 17, 187-202.
                       !      This is the ED-2.0 default, also used in (B)RAMS
                       !  2 - Oncley and Dudhia, 1995: Mon. Wea. Rev., 123, 3344-3357.
                       !      This is used in MM5 and WRF.
                       !  3 - Beljaars and Holtslag, 1991: J. Appl. Meteor., 30, 328-341.
                       !  4 - BH91, using OD95 to find zeta.
   !---------------------------------------------------------------------------------------!

   !=======================================================================================!
   !=======================================================================================!
   !     Parameters used in Euler and Runge-Kutta.                                         !
   !---------------------------------------------------------------------------------------!
   !----- Exponential wind atenuation factor [dimensionless]. -----------------------------!
   real         :: exar
   !----- Scaling factor of Tree Area Index, for computing wtveg [dimensionless]. ---------!
   real         :: covr
   !----- Minimum Ustar [m/s]. ------------------------------------------------------------!
   real         :: ustmin
   !----- Minimum speed for stars [m/s]. --------------------------------------------------!
   real         :: ubmin
   !----- Some parameters that were used in ED-2.0, added here for some tests. ------------!
   real         :: ez
   real         :: vh2vr
   real         :: vh2dh
   !----- Double precision version of some of these variables (for Runge-Kutta). ----------!
   real(kind=8) :: exar8
   real(kind=8) :: ustmin8
   real(kind=8) :: ubmin8
   real(kind=8) :: ez8
   real(kind=8) :: vh2dh8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !     Constants for new canopy turbulence.                                              !
   !---------------------------------------------------------------------------------------!
   !----- Discrete step size in canopy elevation [m]. -------------------------------------!
   real        , parameter :: dz     = 0.5
   !----- Fluid drag coefficient for turbulent flow in leaves. ----------------------------!
   real        , parameter :: Cd0    = 0.2
   !----- Sheltering factor of fluid drag on canopies. ------------------------------------!
   real        , parameter :: Pm     = 1.0
   !----- Surface drag parameters (Massman 1997). -----------------------------------------!
   real        , parameter :: c1_m97 = 0.320 
   real        , parameter :: c2_m97 = 0.264
   real        , parameter :: c3_m97 = 15.1
   !----- Eddy diffusivity due to Von Karman Wakes in gravity flows. ----------------------!
   real        , parameter :: kvwake = 0.001
   !----- Double precision version of these variables, used in the Runge-Kutta scheme. ----!
   real(kind=8), parameter :: dz8     = dble(dz)
   real(kind=8), parameter :: Cd08    = dble(Cd0)
   real(kind=8), parameter :: Pm8     = dble(Pm)
   real(kind=8), parameter :: c1_m978 = dble(c1_m97)
   real(kind=8), parameter :: c2_m978 = dble(c2_m97)
   real(kind=8), parameter :: c3_m978 = dble(c3_m97)
   real(kind=8), parameter :: kvwake8 = dble(kvwake)
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !      Parameters for surface layer models.                                             !
   !---------------------------------------------------------------------------------------!
   !----- Louis (1979) model. -------------------------------------------------------------!
   real   :: bl79        ! b prime parameter
   real   :: csm         ! C* for momentum (eqn. 20, not co2 char. scale)
   real   :: csh         ! C* for heat (eqn.20, not co2 char. scale)
   real   :: dl79        ! ???
   !----- Oncley and Dudhia (1995) model. -------------------------------------------------!
   real   :: bbeta       ! Beta 
   real   :: ribmaxod95  ! Maximum bulk Richardson number
   !----- Beljaars and Holtslag (1991) model. ---------------------------------------------!
   real   :: abh91       ! -a from equation  (28) 
   real   :: bbh91       ! -b from equation  (28)
   real   :: cbh91       !  c from equations (28) and (32)
   real   :: dbh91       !  d from equations (28) and (32)
   real   :: ebh91       ! -a from equation  (32)
   real   :: fbh91       ! -b from equation  (32)
   real   :: cod         ! c/d
   real   :: bcod        ! b*c/d
   real   :: fcod        ! f*c/d
   real   :: etf         ! e * f
   real   :: z0moz0h     ! z0(M)/z0(h)
   real   :: z0hoz0m     ! z0(M)/z0(h)
   real   :: ribmaxbh91  ! Maximum bulk Richardson number
   !----- Used by OD95 and BH91. ----------------------------------------------------------!
   real   :: gamm        ! Gamma for momentum.
   real   :: gamh        ! Gamma for heat.
   real   :: tprandtl    ! Turbulent Prandtl number.
   real   :: vkopr       ! Von Karman / Prandtl number
   !---------------------------------------------------------------------------------------!

   !----- Double precision of all these variables. ----------------------------------------!
   real(kind=8)   :: bl798
   real(kind=8)   :: csm8
   real(kind=8)   :: csh8
   real(kind=8)   :: dl798
   real(kind=8)   :: bbeta8
   real(kind=8)   :: gamm8
   real(kind=8)   :: gamh8
   real(kind=8)   :: ribmaxod958
   real(kind=8)   :: ribmaxbh918
   real(kind=8)   :: tprandtl8
   real(kind=8)   :: vkopr8
   real(kind=8)   :: abh918
   real(kind=8)   :: bbh918
   real(kind=8)   :: cbh918
   real(kind=8)   :: dbh918
   real(kind=8)   :: ebh918
   real(kind=8)   :: fbh918
   real(kind=8)   :: cod8
   real(kind=8)   :: bcod8
   real(kind=8)   :: fcod8
   real(kind=8)   :: etf8
   real(kind=8)   :: z0moz0h8
   real(kind=8)   :: z0hoz0m8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !   Tuneable parameters that will be set in ed_params.f90.                              !
   !---------------------------------------------------------------------------------------!
   

   !---------------------------------------------------------------------------------------!
   !    Minimum leaf water content to be considered.  Values smaller than this will be     !
   ! flushed to zero.  This value is in kg/[m2 leaf], so it will be always scaled by LAI.  !
   !---------------------------------------------------------------------------------------!
   real :: dry_veg_lwater
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   !    Maximum leaf water that plants can hold.  Should leaf water exceed this number,    !
   ! water will be no longer intercepted by the leaves, and any value in excess of this    !
   ! will be promptly removed through shedding.  This value is in kg/[m2 leaf], so it will !
   ! be always scaled by LAI.                                                              !
   !---------------------------------------------------------------------------------------!
   real :: fullveg_lwater
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Parameters to set the maximum vegetation-level aerodynamic resistance.             !
   ! rb_max = rb_inter + rb_slope * TAI.                                                   !
   !---------------------------------------------------------------------------------------!
   real :: rb_slope
   real :: rb_inter

   !---------------------------------------------------------------------------------------!
   !      This is the minimum vegetation height.  [m]                                      !
   !---------------------------------------------------------------------------------------!
   real         :: veg_height_min

   !---------------------------------------------------------------------------------------!
   !      This is the minimum canopy depth that is used to calculate the heat and moisture !
   ! storage capacity in the canopy air [m].                                               !
   !---------------------------------------------------------------------------------------!
   real         :: minimum_canopy_depth
   real(kind=8) :: minimum_canopy_depth8

   !=======================================================================================!
   !=======================================================================================!


   contains
   
   
   
   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the stability  correction function for momentum.            !
   !---------------------------------------------------------------------------------------!
   real function psim(zeta,stable)
      use consts_coms, only : halfpi
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real   , intent(in) :: zeta   ! z/L, z is the height, and L the Obukhov length [ ---]
      logical, intent(in) :: stable ! Flag... This surface layer is stable           [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real                :: xx
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            psim = - bbeta * zeta 
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            psim = abh91 * zeta                                                            &
                 + bbh91 * (zeta - cod) * exp(max(-38.,-dbh91 * zeta))                     &
                 + bcod
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         xx   = sqrt(sqrt(1.0 - gamm * zeta))
         psim = log(0.125 * (1.0+xx) * (1.0+xx) * (1.0 + xx*xx)) - 2.0*atan(xx) + halfpi
      end if
      return
   end function psim
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the stability  correction function for heat (and vapour,    !
   ! and carbon dioxide too.)                                                              !
   !---------------------------------------------------------------------------------------!
   real function psih(zeta,stable)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real   , intent(in) :: zeta   ! z/L, z is the height, and L the Obukhov length [ ---]
      logical, intent(in) :: stable ! Flag... This surface layer is stable           [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real                :: yy
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            psih = - bbeta * zeta 
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            psih = 1.0 - (1.0 + etf * zeta)*sqrt(1.0 + etf * zeta)                         &
                 + fbh91 * (zeta - cod) * exp(max(-38.,-dbh91 * zeta)) + fcod
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         yy   = sqrt(1.0 - gamh * zeta)
         psih = log(0.25 * (1.0+yy) * (1.0+yy))
      end if
      return
   end function psih
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the stability  correction function for momentum.            !
   !---------------------------------------------------------------------------------------!
   real(kind=8) function psim8(zeta,stable)
      use consts_coms, only : halfpi8
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real(kind=8), intent(in) :: zeta   ! z/L, z = height, and L = Obukhov length   [ ---]
      logical     , intent(in) :: stable ! Flag... This surface layer is stable      [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real(kind=8)             :: xx
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            psim8 = - bbeta8 * zeta 
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            psim8 = abh918 * zeta                                                          &
                  + bbh918 * (zeta - cod8) * exp(max(-3.8d1,-dbh918 * zeta))               &
                  + bcod8
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         xx   = sqrt(sqrt(1.d0 - gamm8 * zeta))
         psim8 = log(1.25d-1 * (1.d0+xx) * (1.d0+xx) * (1.d0 + xx*xx))                     &
               - 2.d0*atan(xx) + halfpi8
      end if
      return
   end function psim8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the stability  correction function for heat (and vapour,    !
   ! and carbon dioxide too.)                                                              !
   !---------------------------------------------------------------------------------------!
   real(kind=8) function psih8(zeta,stable)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real(kind=8), intent(in) :: zeta   ! z/L, z = height, and L = Obukhov length   [ ---]
      logical     , intent(in) :: stable ! Flag... This surface layer is stable      [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real(kind=8)             :: yy
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            psih8 = - bbeta8 * zeta 
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            psih8 = 1.d0 - (1.d0 + etf8 * zeta)*sqrt(1.d0 + etf8 * zeta)                   &
                  + fbh918 * (zeta - cod8) * exp(max(-3.8d1,-dbh918 * zeta)) + fcod8
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         yy    = sqrt(1.d0 - gamh8 * zeta)
         psih8 = log(2.5d-1 * (1.d0+yy) * (1.d0+yy))
      end if
      return
   end function psih8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the derivative of the stability correction function for     !
   ! momentum with respect to zeta.                                                        !
   !---------------------------------------------------------------------------------------!
   real function dpsimdzeta(zeta,stable)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real   , intent(in) :: zeta   ! z/L, z is the height, and L the Obukhov length [ ---]
      logical, intent(in) :: stable ! Flag... This surface layer is stable           [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real                :: xx
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            dpsimdzeta = - bbeta 
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            dpsimdzeta = abh91 + bbh91 * (1.0 - dbh91 * zeta + cbh91)                      &
                               * exp(max(-38.,-dbh91 * zeta))
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         xx         = sqrt(sqrt(1.0 - gamm * zeta))
         dpsimdzeta = - gamm / (xx * (1.0+xx) * (1.0 + xx*xx)) 
      end if
      return
   end function dpsimdzeta
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the derivative of the stability correction function for     !
   ! heat/moisture/CO2 with respect to zeta.                                               !
   !---------------------------------------------------------------------------------------!
   real function dpsihdzeta(zeta,stable)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real   , intent(in) :: zeta   ! z/L, z is the height, and L the Obukhov length [ ---]
      logical, intent(in) :: stable ! Flag... This surface layer is stable           [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real                :: yy
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            dpsihdzeta = - bbeta
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            dpsihdzeta = -ebh91 * sqrt(1.0 + etf * zeta)                                   &
                       + fbh91 * (zeta - dbh91 * zeta + cbh91)                             &
                       * exp(max(-38.,-dbh91 * zeta))
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         yy   = sqrt(1.0 - gamh * zeta)
         dpsihdzeta = -gamh / (yy * (1.0 + yy))
      end if
      return
   end function dpsihdzeta
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the derivative of the stability correction function for     !
   ! momentum with respect to zeta.                                                        !
   !---------------------------------------------------------------------------------------!
   real(kind=8) function dpsimdzeta8(zeta,stable)
      use consts_coms, only : halfpi8
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real(kind=8), intent(in) :: zeta   ! z/L, z = height, and L = Obukhov length   [ ---]
      logical     , intent(in) :: stable ! Flag... This surface layer is stable      [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real(kind=8)             :: xx
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            dpsimdzeta8 = - bbeta8
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            dpsimdzeta8 = abh918                                                           &
                           + bbh918 * (1.d0 - dbh918 * zeta + cbh918)                      &
                           * exp(max(-3.8d1,-dbh918 * zeta))
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         xx         = sqrt(sqrt(1.d0 - gamm8 * zeta))
         dpsimdzeta8 = - gamm8 / (xx * (1.d0+xx) * (1.d0 + xx*xx)) 
      end if
      return
   end function dpsimdzeta8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !    This function computes the derivative of the stability correction function for     !
   ! heat/moisture/CO2 with respect to zeta.                                               !
   !---------------------------------------------------------------------------------------!
   real(kind=8) function dpsihdzeta8(zeta,stable)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real(kind=8), intent(in) :: zeta   ! z/L, z = height, and L = Obukhov length   [ ---]
      logical     , intent(in) :: stable ! Flag... This surface layer is stable      [ T|F]
      !----- Local variables. -------------------------------------------------------------!
      real(kind=8)             :: yy
      !------------------------------------------------------------------------------------!
      if (stable) then
         select case (isfclyrm)
         case (2) !----- Oncley and Dudhia (1995). ----------------------------------------!
            dpsihdzeta8 = - bbeta8
         case (3,4) !----- Beljaars and Holtslag (1991). ----------------------------------!
            dpsihdzeta8 = -ebh918 * sqrt(1.d0 + etf8 * zeta)                               &
                        + fbh918 * (zeta - dbh918 * zeta + cbh918)                         &
                        * exp(max(-3.8d1,-dbh918 * zeta))
         end select
      else
         !----- Unstable case, both papers use the same expression. -----------------------!
         yy          = sqrt(1.d0 - gamh8 * zeta)
         dpsihdzeta8 = -gamh8 / (yy * (1.d0 + yy))
      end if
      return
   end function dpsihdzeta8
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !     This function finds the value of zeta for a given Richardson number, reference    !
   ! height and the roughness scale.  This is solved by using the definition of Obukhov    !
   ! length scale as stated in Louis (1979) equation (10), modified to define z/L rather   !
   ! than L.  The solution is found  iteratively since it's not a simple function to       !
   ! invert.  It tries to use Newton's method, which should take care of most cases.  In   !
   ! the unlikely case in which Newton's method fails, switch back to modified Regula      !
   ! Falsi method (Illinois).                                                              !
   !---------------------------------------------------------------------------------------!
   real function zoobukhov(rib,zref,rough,zoz0m,lnzoz0m,zoz0h,lnzoz0h,stable)
      use therm_lib, only : toler  & ! intent(in)
                          , maxfpo & ! intent(in)
                          , maxit  ! ! intent(in)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real   , intent(in) :: rib       ! Bulk Richardson number                    [   ---]
      real   , intent(in) :: zref      ! Reference height                          [     m]
      real   , intent(in) :: rough     ! Roughness length scale                    [     m]
      real   , intent(in) :: zoz0m     ! zref/roughness(momentum)                  [   ---]
      real   , intent(in) :: lnzoz0m   ! ln[zref/roughness(momentum)]              [   ---]
      real   , intent(in) :: zoz0h     ! zref/roughness(heat)                      [   ---]
      real   , intent(in) :: lnzoz0h   ! ln[zref/roughness(heat)]                  [   ---]
      logical, intent(in) :: stable    ! Flag... This surface layer is stable      [   T|F]
      !----- Local variables. -------------------------------------------------------------!
      real                :: fm        ! lnzoz0 - psim(zeta) + psim(zeta0)         [   ---]
      real                :: fh        ! lnzoz0 - psih(zeta) + psih(zeta0)         [   ---]
      real                :: dfmdzeta  ! d(fm)/d(zeta)                             [   ---]
      real                :: dfhdzeta  ! d(fh)/d(zeta)                             [   ---]
      real                :: z0moz     ! Roughness(momentum) / Reference height    [   ---]
      real                :: zeta0m    ! Roughness(momentum) / Obukhov length      [   ---]
      real                :: z0hoz     ! Roughness(heat) / Reference height        [   ---]
      real                :: zeta0h    ! Roughness(heat) / Obukhov length          [   ---]
      real                :: zetaa     ! Smallest guess (or previous guess)        [   ---]
      real                :: zetaz     ! Largest guess (or new guess in Newton's)  [   ---]
      real                :: deriv     ! Function Derivative                       [   ---]
      real                :: fun       ! Function for which we seek a root.        [   ---]
      real                :: funa      ! Smallest guess function.                  [   ---]
      real                :: funz      ! Largest guess function.                   [   ---]
      real                :: delta     ! Aux. var --- 2nd guess for bisection      [   ---]
      real                :: zetamin   ! Minimum zeta for stable case.             [   ---]
      real                :: zetamax   ! Maximum zeta for unstable case.           [   ---]
      real                :: zetasmall ! Number sufficiently close to zero         [   ---]
      integer             :: itb       ! Iteration counters                        [   ---]
      integer             :: itn       ! Iteration counters                        [   ---]
      integer             :: itp       ! Iteration counters                        [   ---]
      logical             :: converged ! Flag... The method converged!             [   T|F]
      logical             :: zside     ! Flag... I'm on the z-side.                [   T|F]
      !------------------------------------------------------------------------------------!

      !------------------------------------------------------------------------------------!
      !     First thing: if the bulk Richardson number is zero or almost zero, then we     !
      ! rather just assign z/L to be the one given by Oncley and Dudhia (1995).  This      !
      ! saves time and also avoids the risk of having zeta with the opposite sign.         !
      !------------------------------------------------------------------------------------!
      zetasmall = vkopr * rib * min(lnzoz0m,lnzoz0h)
      if (rib <= 0. .and. zetasmall > - z0moz0h * toler) then
         zoobukhov = zetasmall
         return
      elseif (rib > 0. .and. zetasmall < z0moz0h * toler) then
         zoobukhov = zetasmall / (1.1 - 5.0 * rib)
         return
      else
         zetamin    =  toler
         zetamax    = -toler
      end if

      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
      !write(unit=89,fmt='(60a1)') ('-',itn=1,60)
      !write(unit=89,fmt='(5(a,1x,f11.4,1x),a,l1)')                                         &
      !   'Input values: Rib =',rib,'zref=',zref,'rough=',rough,'zoz0=',zoz0                &
      !           ,'lnzoz0=',lnzoz0,'stable=',stable
      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!


      !----- Defining some values that won't change during the iterative method. ----------!
      z0moz = 1. / zoz0m
      z0hoz = 1. / zoz0h

      !------------------------------------------------------------------------------------!
      !     First guess, using Oncley and Dudhia (1995) approximation for unstable case.   !
      ! We won't use the stable case to avoid FPE or zeta with opposite sign when          !
      ! Ri > 0.20.                                                                         !
      !------------------------------------------------------------------------------------!
      zetaa = vkopr * rib * lnzoz0m

      !----- Finding the function and its derivative. -------------------------------------!
      zeta0m   = zetaa * z0moz
      zeta0h   = zetaa * z0hoz
      fm       = lnzoz0m - psim(zetaa,stable) + psim(zeta0m,stable)
      fh       = lnzoz0h - psih(zetaa,stable) + psih(zeta0h,stable)
      dfmdzeta = z0moz * dpsimdzeta(zeta0m,stable) - dpsimdzeta(zetaa,stable)
      dfhdzeta = z0hoz * dpsihdzeta(zeta0h,stable) - dpsihdzeta(zetaa,stable)
      funa     = vkopr * rib * fm * fm / fh - zetaa
      deriv    = vkopr * rib * (2. * fm * dfmdzeta * fh - fm * fm * dfhdzeta)              &
               / (fh * fh) - 1.

      !----- Copying just in case it fails at the first iteration. ------------------------!
      zetaz = zetaa
      fun   = funa

      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
      !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
      !   '1STGSS: itn=',0,'bisection=',.false.,'zetaz=',zetaz,'fun=',fun,'fm=',fm          &
      !  ,'fh=',fh,'dfmdzeta=',dfmdzeta,'dfhdzeta=',dfhdzeta,'deriv=',deriv
      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!

      !----- Enter Newton's method loop. --------------------------------------------------!
      converged = .false.
      newloop: do itn = 1, maxfpo/6
         !---------------------------------------------------------------------------------!
         !     Newton's method converges fast when it's on the right track, but there are  !
         ! cases in which it becomes ill-behaved.  Two situations are known to cause       !
         ! trouble:                                                                        !
         ! 1.  If the derivative is tiny, the next guess can be too far from the actual    !
         !     answer;                                                                     !
         ! 2.  For this specific problem, when zeta is too close to zero.  In this case    !
         !     the derivative will tend to infinity at this point and Newton's method is   !
         !     not going to perform well and can potentially enter in a weird behaviour or !
         !     lead to the wrong answer.  In any case, so we rather go with bisection.     !
         !---------------------------------------------------------------------------------!
         if (abs(deriv) < toler) then
            exit newloop
         elseif(stable .and. (zetaz - fun/deriv < zetamin)) then
            exit newloop
         elseif((.not. stable) .and. (zetaz - fun/deriv > zetamax)) then
            exit newloop
         end if

         !----- Copying the previous guess ------------------------------------------------!
         zetaa = zetaz
         funa  = fun
         !----- New guess, its function and derivative evaluation -------------------------!
         zetaz = zetaa - fun/deriv

         zeta0m   = zetaz * z0moz
         zeta0h   = zetaz * z0hoz
         fm       = lnzoz0m - psim(zetaz,stable) + psim(zeta0m,stable)
         fh       = lnzoz0h - psih(zetaz,stable) + psih(zeta0h,stable)
         dfmdzeta = z0moz * dpsimdzeta(zeta0m,stable) - dpsimdzeta(zetaz,stable)
         dfhdzeta = z0hoz * dpsihdzeta(zeta0h,stable) - dpsihdzeta(zetaz,stable)
         fun      = vkopr * rib * fm * fm / fh - zetaz
         deriv    = vkopr * rib * (2. * fm * dfmdzeta * fh - fm * fm * dfhdzeta)           &
                  / (fh * fh) - 1.

         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
         !   'NEWTON: itn=',itn,'bisection=',.false.,'zetaz=',zetaz,'fun=',fun,'fm=',fm        &
         !  ,'fh=',fh,'dfmdzeta=',dfmdzeta,'dfhdzeta=',dfhdzeta,'deriv=',deriv
         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         converged = abs(zetaz-zetaa) < toler * abs(zetaz)

         if (converged) then
            zoobukhov = 0.5 * (zetaa+zetaz)
            return
         elseif (fun == 0.0) then !---- Converged by luck. --------------------------------!
            zoobukhov = zetaz
            return
         end if
      end do newloop

      !------------------------------------------------------------------------------------!
      !     If we reached this point then it's because Newton's method failed or it has    !
      ! become too dangerous.  We use the Regula Falsi (Illinois) method, which is just a  !
      ! fancier bisection.  For this we need two guesses, and the guesses must have        !
      ! opposite signs.                                                                    !
      !------------------------------------------------------------------------------------!
      if (funa * fun < 0.0) then
         funz  = fun
         zside = .true. 
      else
         if (abs(fun-funa) < 100. * toler * abs(zetaa)) then
            if (stable) then
               delta = max(0.5 * abs(zetaa-zetamin),100. * toler * abs(zetaa))
            else
               delta = max(0.5 * abs(zetaa-zetamax),100. * toler * abs(zetaa))
            end if
         else
            if (stable) then
               delta = max(abs(funa * (zetaz-zetaa)/(fun-funa))                            &
                          ,100. * toler * abs(zetaa)                                       &
                          ,0.5 * abs(zetaa-zetamin))
            else
               delta = max(abs(funa * (zetaz-zetaa)/(fun-funa))                            &
                          ,100. * toler * abs(zetaa)                                       &
                          ,0.5 * abs(zetaa-zetamax))
            end if
         end if
         if (stable) then
            zetaz = max(zetamin,zetaa + delta)
         else
            zetaz = min(zetamax,zetaa + delta)
         end if
         zside = .false.
         zgssloop: do itp=1,maxfpo
            if (stable) then
               zetaz    = max(zetamin,zetaa + real((-1)**itp * (itp+3)/2) * delta)
            else
               zetaz    = min(zetamax,zetaa + real((-1)**itp * (itp+3)/2) * delta)
            end if
            zeta0m   = zetaz * z0moz
            zeta0h   = zetaz * z0hoz
            fm       = lnzoz0m - psim(zetaz,stable) + psim(zeta0m,stable)
            fh       = lnzoz0h - psih(zetaz,stable) + psih(zeta0h,stable)
            funz     = vkopr * rib * fm * fm / fh - zetaz
            zside    = funa * funz < 0.0
            !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
            !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
            !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                 &
            !   '2NDGSS: itp=',itp,'zside=',zside,'zetaa=',zetaa,'zetaz=',zetaz             &
            !  ,'funa=',funa,'funz=',funz,'fm=',fm,'fh=',fh,'delta=',delta
            !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
            !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
            if (zside) exit zgssloop
         end do zgssloop
         if (.not. zside) then
            write (unit=*,fmt='(a)') '=================================================='
            write (unit=*,fmt='(a)') '    No second guess for you...'
            write (unit=*,fmt='(a)') '=================================================='
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zref   =',zref   ,'rough  =',rough
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'lnzoz0m=',lnzoz0m,'lnzoz0h=',lnzoz0h
            write (unit=*,fmt='(1(a,1x,es14.7,1x))') 'rib    =',rib
            write (unit=*,fmt='(1(a,1x,l1,1x))')     'stable =',stable
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'fun    =',fun    ,'delta  =',delta
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zetaa  =',zetaa  ,'funa   =',funa
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zetaz  =',zetaz  ,'funz   =',funz
            call fatal_error('Failed finding the second guess for regula falsi'            &
                            ,'zoobukhov','canopy_air_coms.f90')
         end if
      end if

      !----- Now we are ready to start the regula falsi method. ---------------------------!
      bisloop: do itb=itn,maxfpo
         zoobukhov = (funz*zetaa-funa*zetaz)/(funz-funa)

         !---------------------------------------------------------------------------------!
         !     Now that we updated the guess, check whether they are really close. If so,  !
         ! it converged, I can use this as my guess.                                       !
         !---------------------------------------------------------------------------------!
         converged = abs(zoobukhov-zetaa) < toler * abs(zoobukhov)
         if (converged) exit bisloop

         !------ Finding the new function -------------------------------------------------!
         zeta0m   = zoobukhov * z0moz
         zeta0h   = zoobukhov * z0hoz
         fm       = lnzoz0m - psim(zoobukhov,stable) + psim(zeta0m,stable)
         fh       = lnzoz0h - psih(zoobukhov,stable) + psih(zeta0h,stable)
         fun      = vkopr * rib * fm * fm / fh - zoobukhov

         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
         !   'REGULA: itn=',itb,'bisection=',.true.,'zetaa=',zetaa,'zetaz=',zetaz,'fun=',fun   &
         !  ,'funa=',funa,'funz=',funz,'fm=',fm,'fh=',fh
         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!

         !------ Defining my new interval based on the intermediate value theorem. --------!
         if (fun*funa < 0. ) then
            zetaz = zoobukhov
            funz  = fun
            !----- If we are updating zside again, modify aside (Illinois method) ---------!
            if (zside) funa = funa * 0.5
            !----- We just updated zside, setting zside to true. --------------------------!
            zside = .true.
         else
            zetaa = zoobukhov
            funa  = fun
            !----- If we are updating aside again, modify aside (Illinois method) ---------!
            if (.not. zside) funz = funz * 0.5
            !----- We just updated aside, setting aside to true. --------------------------!
            zside = .false.
         end if
      end do bisloop

      if (.not.converged) then
         write (unit=*,fmt='(a)') '-------------------------------------------------------'
         write (unit=*,fmt='(a)') ' Zeta finding didn''t converge!!!'
         write (unit=*,fmt='(a,1x,i5,1x,a)') ' I gave up, after',maxfpo,'iterations...'
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a)') ' Input values.'
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a,1x,f12.4)' ) 'rib             [   ---] =',rib
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zref            [     m] =',zref
         write (unit=*,fmt='(a,1x,f12.4)' ) 'rough           [     m] =',rough
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoz0m           [   ---] =',zoz0m
         write (unit=*,fmt='(a,1x,f12.4)' ) 'lnzoz0m         [   ---] =',lnzoz0m
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoz0h           [   ---] =',zoz0h
         write (unit=*,fmt='(a,1x,f12.4)' ) 'lnzoz0h         [   ---] =',lnzoz0h
         write (unit=*,fmt='(a,1x,l1)'    ) 'stable          [   T|F] =',stable
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a)') ' Last iteration outcome (downdraft values).'
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zetaa           [   ---] =',zetaa
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zetaz           [   ---] =',zetaz
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fun             [   ---] =',fun
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fm              [   ---] =',fm
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fh              [   ---] =',fh
         write (unit=*,fmt='(a,1x,f12.4)' ) 'funa            [   ---] =',funa
         write (unit=*,fmt='(a,1x,f12.4)' ) 'funz            [   ---] =',funz
         write (unit=*,fmt='(a,1x,f12.4)' ) 'deriv           [   ---] =',deriv
         write (unit=*,fmt='(a,1x,es12.4)') 'toler           [   ---] =',toler
         write (unit=*,fmt='(a,1x,es12.4)') 'error           [   ---] ='                   &
                                                            ,abs(zetaz-zetaa)/abs(zetaz)
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoobukhov       [   ---] =',zoobukhov
         write (unit=*,fmt='(a)') '-------------------------------------------------------'

         call fatal_error('Zeta didn''t converge, giving up!!!'                            &
                         ,'zoobukhov','canopy_air_coms.f90')
      end if

      return
   end function zoobukhov
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   !     This function finds the value of zeta for a given Richardson number, reference    !
   ! height and the roughness scale.  This is solved by using the definition of Obukhov    !
   ! length scale as stated in Louis (1979) equation (10), modified to define z/L rather   !
   ! than L.  The solution is found  iteratively since it's not a simple function to       !
   ! invert.  It tries to use Newton's method, which should take care of most cases.  In   !
   ! the unlikely case in which Newton's method fails, switch back to modified Regula      !
   ! Falsi method (Illinois).                                                              !
   !---------------------------------------------------------------------------------------!
   real(kind=8) function zoobukhov8(rib,zref,rough,zoz0m,lnzoz0m,zoz0h,lnzoz0h,stable)
      use therm_lib8, only : toler8 & ! intent(in)
                           , maxfpo & ! intent(in)
                           , maxit  ! ! intent(in)
      implicit none
      !----- Arguments. -------------------------------------------------------------------!
      real(kind=8), intent(in) :: rib       ! Bulk Richardson number               [   ---]
      real(kind=8), intent(in) :: zref      ! Reference height                     [     m]
      real(kind=8), intent(in) :: rough     ! Roughness length scale               [     m]
      real(kind=8), intent(in) :: zoz0m     ! zref/roughness(momentum)             [   ---]
      real(kind=8), intent(in) :: lnzoz0m   ! ln[zref/roughness(momentum)]         [   ---]
      real(kind=8), intent(in) :: zoz0h     ! zref/roughness(heat)                 [   ---]
      real(kind=8), intent(in) :: lnzoz0h   ! ln[zref/roughness(heat)]             [   ---]
      logical     , intent(in) :: stable    ! Flag... This surface layer is stable [   T|F]
      !----- Local variables. -------------------------------------------------------------!
      real(kind=8)             :: fm        ! lnzoz0 - psim(zeta) + psim(zeta0)    [   ---]
      real(kind=8)             :: fh        ! lnzoz0 - psih(zeta) + psih(zeta0)    [   ---]
      real(kind=8)             :: dfmdzeta  ! d(fm)/d(zeta)                        [   ---]
      real(kind=8)             :: dfhdzeta  ! d(fh)/d(zeta)                        [   ---]
      real(kind=8)             :: z0moz     ! Roughness(momentum) / Reference hgt. [   ---]
      real(kind=8)             :: zeta0m    ! Roughness(momentum) / Obukhov length [   ---]
      real(kind=8)             :: z0hoz     ! Roughness(heat) / Reference height   [   ---]
      real(kind=8)             :: zeta0h    ! Roughness(heat) / Obukhov length     [   ---]
      real(kind=8)             :: zetaa     ! Smallest guess (or previous guess)   [   ---]
      real(kind=8)             :: zetaz     ! Largest guess (new guess in Newton)  [   ---]
      real(kind=8)             :: deriv     ! Function Derivative                  [   ---]
      real(kind=8)             :: fun       ! Function for which we seek a root.   [   ---]
      real(kind=8)             :: funa      ! Smallest guess function.             [   ---]
      real(kind=8)             :: funz      ! Largest guess function.              [   ---]
      real(kind=8)             :: delta     ! Aux. var --- 2nd guess for bisection [   ---]
      real(kind=8)             :: zetamin   ! Minimum zeta for stable case.        [   ---]
      real(kind=8)             :: zetamax   ! Maximum zeta for unstable case.      [   ---]
      real(kind=8)             :: zetasmall ! Zeta dangerously close to zero       [   ---]
      integer                  :: itn       ! Iteration counters                   [   ---]
      integer                  :: itb       ! Iteration counters                   [   ---]
      integer                  :: itp       ! Iteration counters                   [   ---]
      logical                  :: converged ! Flag... The method converged!        [   T|F]
      logical                  :: zside     ! Flag... I'm on the z-side.           [   T|F]
      !------------------------------------------------------------------------------------!


      !------------------------------------------------------------------------------------!
      !     First thing: if the bulk Richardson number is zero or almost zero, then we     !
      ! rather just assign z/L to be the one given by Oncley and Dudhia (1995).  This      !
      ! saves time and also avoids the risk of having zeta with the opposite sign.         !
      !------------------------------------------------------------------------------------!
      zetasmall = vkopr8 * rib * min(lnzoz0m,lnzoz0h)
      if (rib <= 0.d0 .and. zetasmall > - z0moz0h8 * toler8) then
         zoobukhov8 = zetasmall
         return
      elseif (rib > 0.d0 .and. zetasmall < z0moz0h8 * toler8) then
         zoobukhov8 = zetasmall / (1.1d0 - 5.0d0 * rib)
         return
      else
         zetamin    =  toler8
         zetamax    = -toler8
      end if

      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
      !write(unit=89,fmt='(60a1)') ('-',itn=1,60)
      !write(unit=89,fmt='(5(a,1x,f11.4,1x),a,l1)')                                         &
      !   'Input values: Rib =',rib,'zref=',zref,'rough=',rough,'zoz0=',zoz0                &
      !           ,'lnzoz0=',lnzoz0,'stable=',stable
      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!


      !----- Defining some values that won't change during the iterative method. ----------!
      z0moz = 1.d0 / zoz0m
      z0hoz = 1.d0 / zoz0h

      !------------------------------------------------------------------------------------!
      !     First guess, using Oncley and Dudhia (1995) approximation for unstable case.   !
      ! We won't use the stable case to avoid FPE or zeta with opposite sign when          !
      ! Ri > 0.20.                                                                         !
      !------------------------------------------------------------------------------------!
      zetaa = vkopr8 * rib * lnzoz0m

      !----- Finding the function and its derivative. -------------------------------------!
      zeta0m   = zetaa * z0moz
      zeta0h   = zetaa * z0hoz
      fm       = lnzoz0m - psim8(zetaa,stable) + psim8(zeta0m,stable)
      fh       = lnzoz0h - psih8(zetaa,stable) + psih8(zeta0h,stable)
      dfmdzeta = z0moz * dpsimdzeta8(zeta0m,stable) - dpsimdzeta8(zetaa,stable)
      dfhdzeta = z0hoz * dpsihdzeta8(zeta0h,stable) - dpsihdzeta8(zetaa,stable)
      funa     = vkopr8 * rib * fm * fm / fh - zetaa
      deriv    = vkopr8 * rib * (2.d0 * fm * dfmdzeta * fh - fm * fm * dfhdzeta)           &
               / (fh * fh) - 1.d0

      !----- Copying just in case it fails at the first iteration. ------------------------!
      zetaz = zetaa
      fun   = funa

      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
      !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
      !   '1STGSS: itn=',0,'bisection=',.false.,'zetaz=',zetaz,'fun=',fun,'fm=',fm          &
      !  ,'fh=',fh,'dfmdzeta=',dfmdzeta,'dfhdzeta=',dfhdzeta,'deriv=',deriv
      !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
      !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!

      !----- Enter Newton's method loop. --------------------------------------------------!
      converged = .false.
      newloop: do itn = 1, maxfpo/6
         !---------------------------------------------------------------------------------!
         !     Newton's method converges fast when it's on the right track, but there are  !
         ! cases in which it becomes ill-behaved.  Two situations are known to cause       !
         ! trouble:                                                                        !
         ! 1.  If the derivative is tiny, the next guess can be too far from the actual    !
         !     answer;                                                                     !
         ! 2.  For this specific problem, when zeta is too close to zero.  In this case    !
         !     the derivative will tend to infinity at this point and Newton's method is   !
         !     not going to perform well and can potentially enter in a weird behaviour or !
         !     lead to the wrong answer.  In any case, so we rather go with bisection.     !
         !---------------------------------------------------------------------------------!
         if (abs(deriv) < toler8) then
            exit newloop
         elseif(stable .and. (zetaz - fun/deriv < zetamin)) then
            exit newloop
         elseif((.not. stable) .and. (zetaz - fun/deriv > zetamax)) then
            exit newloop
         end if

         !----- Copying the previous guess ------------------------------------------------!
         zetaa = zetaz
         funa  = fun
         !----- New guess, its function and derivative evaluation -------------------------!
         zetaz = zetaa - fun/deriv

         zeta0m   = zetaz * z0moz
         zeta0h   = zetaz * z0hoz
         fm       = lnzoz0m - psim8(zetaz,stable) + psim8(zeta0m,stable)
         fh       = lnzoz0h - psih8(zetaz,stable) + psih8(zeta0h,stable)
         dfmdzeta = z0moz * dpsimdzeta8(zeta0m,stable) - dpsimdzeta8(zetaz,stable)
         dfhdzeta = z0hoz * dpsihdzeta8(zeta0h,stable) - dpsihdzeta8(zetaz,stable)
         fun      = vkopr8 * rib * fm * fm / fh - zetaz
         deriv    = vkopr8 * rib * (2.d0 * fm * dfmdzeta * fh - fm * fm * dfhdzeta)        &
                  / (fh * fh) - 1.d0

         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
         !   'NEWTON: itn=',itn,'bisection=',.false.,'zetaz=',zetaz,'fun=',fun,'fm=',fm        &
         !  ,'fh=',fh,'dfmdzeta=',dfmdzeta,'dfhdzeta=',dfhdzeta,'deriv=',deriv
         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         converged = abs(zetaz-zetaa) < toler8 * abs(zetaz)

         if (converged) then
            zoobukhov8 = 5.d-1 * (zetaa+zetaz)
            return
         elseif (fun == 0.d0) then !---- Converged by luck. -------------------------------!
            zoobukhov8 = zetaz
            return
         end if
      end do newloop

      !------------------------------------------------------------------------------------!
      !     If we reached this point then it's because Newton's method failed or it has    !
      ! become too dangerous.  We use the Regula Falsi (Illinois) method, which is just a  !
      ! fancier bisection.  For this we need two guesses, and the guesses must have        !
      ! opposite signs.                                                                    !
      !------------------------------------------------------------------------------------!
      if (funa * fun < 0.d0) then
         funz  = fun
         zside = .true. 
      else
         if (abs(fun-funa) < 1.d2 * toler8 * abs(zetaa)) then
            if (stable) then
               delta = max(5.d-1 * abs(zetaa-zetamin),1.d2 * toler8 * abs(zetaa))
            else
               delta = max(5.d-1 * abs(zetaa-zetamax),1.d2 * toler8 * abs(zetaa))
            end if
         else
            if (stable) then
               delta = max(abs(funa * (zetaz-zetaa)/(fun-funa))                            &
                          ,1.d2 * toler8 * abs(zetaa)                                      &
                          ,5.d-1 * abs(zetaa-zetamin))
            else
               delta = max(abs(funa * (zetaz-zetaa)/(fun-funa))                            &
                          ,1.d2 * toler8 * abs(zetaa)                                      &
                          ,5.d-1 * abs(zetaa-zetamax))
            end if
         end if
         if (stable) then
            zetaz = max(zetamin,zetaa + delta)
         else
            zetaz = min(zetamax,zetaa + delta)
         end if
         zside = .false.
         zgssloop: do itp=1,maxfpo
            if (stable) then
               zetaz    = max(zetamin,zetaa + dble((-1)**itp * (itp+3)/2) * delta)
            else
               zetaz    = min(zetamax,zetaa + dble((-1)**itp * (itp+3)/2) * delta)
            end if
            zeta0m   = zetaz * z0moz
            zeta0h   = zetaz * z0hoz
            fm       = lnzoz0m - psim8(zetaz,stable) + psim8(zeta0m,stable)
            fh       = lnzoz0h - psih8(zetaz,stable) + psih8(zeta0h,stable)
            funz     = vkopr8 * rib * fm * fm / fh - zetaz
            zside    = funa * funz < 0.d0
            !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
            !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
            !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                 &
            !   '2NDGSS: itp=',itp,'zside=',zside,'zetaa=',zetaa,'zetaz=',zetaz             &
            !  ,'funa=',funa,'funz=',funz,'fm=',fm,'fh=',fh,'delta=',delta
            !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
            !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
            if (zside) exit zgssloop
         end do zgssloop
         if (.not. zside) then
            write (unit=*,fmt='(a)') '=================================================='
            write (unit=*,fmt='(a)') '    No second guess for you...'
            write (unit=*,fmt='(a)') '=================================================='
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zref   =',zref  ,'rough  =',rough
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'lnzoz0m=',lnzoz0m,'lnzoz0h=',lnzoz0h
            write (unit=*,fmt='(1(a,1x,es14.7,1x))') 'rib    =',rib
            write (unit=*,fmt='(1(a,1x,l1,1x))')     'stable =',stable
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'fun    =',fun   ,'delta  =',delta
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zetaa  =',zetaa ,'funa   =',funa
            write (unit=*,fmt='(2(a,1x,es14.7,1x))') 'zetaz  =',zetaz ,'funz   =',funz
            call fatal_error('Failed finding the second guess for regula falsi'            &
                            ,'zoobukhov8','canopy_air_coms.f90')
         end if
      end if

      !----- Now we are ready to start the regula falsi method. ---------------------------!
      bisloop: do itb=itn,maxfpo
         zoobukhov8 = (funz*zetaa-funa*zetaz)/(funz-funa)

         !---------------------------------------------------------------------------------!
         !     Now that we updated the guess, check whether they are really close. If so,  !
         ! it converged, I can use this as my guess.                                       !
         !---------------------------------------------------------------------------------!
         converged = abs(zoobukhov8-zetaa) < toler8 * abs(zoobukhov8)
         if (converged) exit bisloop

         !------ Finding the new function -------------------------------------------------!
         zeta0m   = zoobukhov8 * z0moz
         zeta0h   = zoobukhov8 * z0hoz
         fm       = lnzoz0m - psim8(zoobukhov8,stable) + psim8(zeta0m,stable)
         fh       = lnzoz0h - psih8(zoobukhov8,stable) + psih8(zeta0h,stable)
         fun      = vkopr8 * rib * fm * fm / fh - zoobukhov8

         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!
         !write(unit=89,fmt='(a,1x,i5,1x,a,1x,l1,1x,7(1x,a,1x,es12.5))')                       &
         !   'REGULA: itn=',itb,'bisection=',.true.,'zetaa=',zetaa,'zetaz=',zetaz,'fun=',fun   &
         !  ,'funa=',funa,'funz=',funz,'fm=',fm,'fh=',fh
         !<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>!
         !><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><!

         !------ Defining my new interval based on the intermediate value theorem. --------!
         if (fun*funa < 0.d0 ) then
            zetaz = zoobukhov8
            funz  = fun
            !----- If we are updating zside again, modify aside (Illinois method) ---------!
            if (zside) funa = funa * 5.d-1
            !----- We just updated zside, setting zside to true. --------------------------!
            zside = .true.
         else
            zetaa = zoobukhov8
            funa  = fun
            !----- If we are updating aside again, modify aside (Illinois method) ---------!
            if (.not. zside) funz = funz * 5.d-1
            !----- We just updated aside, setting aside to true. --------------------------!
            zside = .false.
         end if
      end do bisloop

      if (.not.converged) then
         write (unit=*,fmt='(a)') '-------------------------------------------------------'
         write (unit=*,fmt='(a)') ' Zeta finding didn''t converge!!!'
         write (unit=*,fmt='(a,1x,i5,1x,a)') ' I gave up, after',maxfpo,'iterations...'
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a)') ' Input values.'
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a,1x,f12.4)' ) 'rib             [   ---] =',rib
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zref            [     m] =',zref
         write (unit=*,fmt='(a,1x,f12.4)' ) 'rough           [     m] =',rough
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoz0m           [   ---] =',zoz0m
         write (unit=*,fmt='(a,1x,f12.4)' ) 'lnzoz0m         [   ---] =',lnzoz0m
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoz0h           [   ---] =',zoz0h
         write (unit=*,fmt='(a,1x,f12.4)' ) 'lnzoz0h         [   ---] =',lnzoz0h
         write (unit=*,fmt='(a,1x,l1)'    ) 'stable          [   T|F] =',stable
         write (unit=*,fmt='(a)') ' '
         write (unit=*,fmt='(a)') ' Last iteration outcome (downdraft values).'
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zetaa           [   ---] =',zetaa
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zetaz           [   ---] =',zetaz
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fun             [   ---] =',fun
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fm              [   ---] =',fm
         write (unit=*,fmt='(a,1x,f12.4)' ) 'fh              [   ---] =',fh
         write (unit=*,fmt='(a,1x,f12.4)' ) 'funa            [   ---] =',funa
         write (unit=*,fmt='(a,1x,f12.4)' ) 'funz            [   ---] =',funz
         write (unit=*,fmt='(a,1x,f12.4)' ) 'deriv           [   ---] =',deriv
         write (unit=*,fmt='(a,1x,es12.4)') 'toler           [   ---] =',toler8
         write (unit=*,fmt='(a,1x,es12.4)') 'error           [   ---] ='                   &
                                                            ,abs(zetaz-zetaa)/abs(zetaz)
         write (unit=*,fmt='(a,1x,f12.4)' ) 'zoobukhov8      [   ---] =',zoobukhov8
         write (unit=*,fmt='(a)') '-------------------------------------------------------'

         call fatal_error('Zeta didn''t converge, giving up!!!'                            &
                         ,'zoobukhov8','canopy_air_coms.f90')
      end if

      return
   end function zoobukhov8
   !=======================================================================================!
   !=======================================================================================!
end module canopy_air_coms
!==========================================================================================!
!==========================================================================================!
