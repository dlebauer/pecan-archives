!==========================================================================================!
!==========================================================================================!
!     Module mem_globrad.                                                                  !
!     This module contains some parameters and flags used by CARMA radiation model.        !
!------------------------------------------------------------------------------------------!
module mem_globrad  

   use mem_aerad    , only : nsol    & ! intent(in) 
                           , nwave   & ! intent(in)
                           , ngroup  ! ! intent(in)
   use rconstants   , only : gcgs    & ! intent(in)
                           , day_sec ! ! intent(in)
   implicit none

   !---------------------------------------------------------------------------------------!
   !     Define the dimensions used by the radiation model.                                !
   !---------------------------------------------------------------------------------------!
   integer :: nvert                            ! Maximum number of layers.
   integer :: nrad                             ! Maximum number of aerosol radius bins
   integer :: nlayer                           ! Maximum number of layer boundaries
   integer :: ndbl                             ! 2 * nlayer
   integer :: nradver                          ! nrad * nvert
   integer :: nradlay                          ! nrad * nlayer
   integer, parameter :: nsolp  = 83           ! Number of solar probability intervals.
   integer, parameter :: nirp   = 71           ! Number of infra-red probability intervals.
   integer, parameter :: ntotal = nsolp + nirp ! Total number of probability intervals. 
   integer, parameter :: ngauss = 3            ! Number of Gauss quadrature points.
 
   integer, parameter :: nlow = 12500          ! Used in the Planck function calculation.
   integer, parameter :: nhigh = 35000         ! Used in the Planck function calculation.
   integer            :: ncount                ! nhigh - nlow 
 
   !---------------------------------------------------------------------------------------!
   !       Define values of flag used for reading/writing Mie coefficients.                !
   !---------------------------------------------------------------------------------------!
   logical, parameter :: l_read  = .false.
   logical, parameter :: l_write = .true.
 
   !----- Constant parameters that might be specified by an external model. ---------------!
   real, dimension(:), allocatable :: o3mix

   !---------------------------------------------------------------------------------------!
   !     Ozone mass mixing ratio (g/g) at pressure levels defined by PJ vector.  Current   !
   ! values are taken from the US standard atmosphere mid-latitude profile.                !
   !---------------------------------------------------------------------------------------!
   real   , dimension(6)                 :: o3mixp
   real                                  :: o3c
   real                                  :: vrat
   real                                  :: ptop
   real   , dimension(:)   , allocatable :: rmin
   real   , dimension(:,:) , allocatable :: r
   logical, dimension(:)   , allocatable :: is_grp_ice
   real   , dimension(:,:) , allocatable :: core_rad
   real   , dimension(:,:) , allocatable :: coreup_rad

   real   , dimension(  6)               :: pj
   real   , dimension(4,6)               :: ako3
   real   , dimension(6,6)               :: akco2
   real   , dimension(54,6)              :: akh2o
 
   !----- Time-dependent variables that might be specified by an external model. ----------!
   real                                  :: u0ext
   real                                  :: albedo_sfc
   real                                  :: emisir
   real   , dimension(:)   , allocatable :: p
   real   , dimension(:)   , allocatable :: t
   real   , dimension(:)   , allocatable :: q
 
   !---------------------------------------------------------------------------------------!
   !     Output variables, calculated by the radiation model, that might be used by the    !
   ! external model.                                                                       !
   !---------------------------------------------------------------------------------------!
   real   , dimension(:)   , allocatable :: heati
   real   , dimension(:)   , allocatable :: heats
   real   , dimension(:)   , allocatable :: heat
 
   !----- Variables initialised in setuprad. ----------------------------------------------!
   integer                               :: jdble
   integer                               :: jn
   real   , dimension(:)   , allocatable :: sflx
   real   , dimension(:)   , allocatable :: wvln
   real   , dimension(:)   , allocatable :: emis
   integer, dimension(:)   , allocatable :: ltemp
   real   , dimension(:)   , allocatable :: sol
   real   , dimension(:)   , allocatable :: tauray
   real   , dimension(:,:) , allocatable :: gol
   real   , dimension(:,:) , allocatable :: wol
   integer, dimension(:,:) , allocatable :: nprobi

   !----- Roundoff error precision (aka. machine epsilon). --------------------------------!
   real        , parameter :: roundoff  = epsilon(1.)
   real(kind=8), parameter :: roundoff8 = dble(roundoff)

   !----- Bergstrom's water vapour continuum fix. -----------------------------------------!
   real, dimension(nirp) :: contnm
  
   !---------------------------------------------------------------------------------------!
   !     CORERAD  - Radius of core of aerosol particles.                                   !
   !     COREREAL - Real part of refractive index of cores.                                !
   !     COREIMAG - Imaginary part of refractive index of cores.                           !
   !---------------------------------------------------------------------------------------!
   real, parameter :: corereal=2.0
   real, parameter :: coreimag=1.0
  
   !---------------------------------------------------------------------------------------!
   !     Gauss angles and Gauss weights for Gaussian integration moments (use first moment !
   ! values) n=3.                                                                          !
   !---------------------------------------------------------------------------------------!
   real, dimension(ngauss)  :: gangle
   real, dimension(ngauss)  :: gratio
   real, dimension(ngauss)  :: gweight
   !---------------------------------------------------------------------------------------!
    
   real, dimension( ntotal) :: weight

   !----- Real and imaginary parts of refractive index for liquid water. ------------------!
   real, dimension(2,nwave) :: treal
   real, dimension(2,nwave) :: ttmag

   !---------------------------------------------------------------------------------------!
   !     Nprob is the number of probability intervals in each wavelength interval.  Notice !
   ! that wave bins 11 and 12 are swapped(this is done for historical reasons).  There-    !
   ! fore, cross sections, weights, refractive indicies etc. for bins 11 and 12 must be    !
   ! swapped as well.                                                                      !
   !---------------------------------------------------------------------------------------!
   integer, dimension(ntotal) :: nprob
 
   real, allocatable :: aco2(:)
   real, allocatable :: ah2o(:)
   real, allocatable :: ao2(:)
   real, allocatable :: ao3(:)
   real, allocatable :: planck(:,:)
   real, allocatable :: xsecta(:,:)
   real, allocatable :: rup(:,:)
   real, allocatable :: qscat(:,:,:)
   logical           :: iblackbody_above
   real, allocatable :: qbrqs(:,:,:)
   real              :: t_above
   real, allocatable :: rdqext(:,:,:)

   real, allocatable :: co2(:)
   real, allocatable :: rdh2o(:)
   real, allocatable :: o2(:)
   real, allocatable :: o3(:)
   real, allocatable :: pbar(:)
   real, allocatable :: tt(:)

   real :: tgrnd
   real :: u0
   integer :: isl
   integer :: ir
   integer :: irs
   real, parameter :: cpcon =   1.006
   real, parameter :: fdegday = 1.0E-4 * gcgs * day_sec/cpcon

   !
   !      DATA (PSO2(I),I=1,77)  /  10*0.0, 4*0.75, 63*0.0      /
   !
   real :: pso2(ntotal)
                                            
   real :: pso3(ntotal)
    
   !      DATA (PSH2O(I),I=1,77) /
   !     1      14*0.0, 3*0.54, 3*0.54, 0.0, 4*0.54, 0.0, 4*0.52,
   !     2      4*0.44, 3*0.00, 4*0.62, 5*0.0, 20*0.60,   4*0.60,
   !     3      7*0.0                     /
 
   real :: psh2o(ntotal)
  
   !      DATA (PSCO2(I),I=1,77) /
   !     1       41*0.0, 4*0.82, 0.0, 20*0.88, 5*0.0, 6*0.93    /
   real :: psco2(ntotal)
   !
   !     WAVE REFERS TO THE WAVE LENGTHS OF THE CENTERS OF THE SOLAR FLUX
   !     BINS AND THE EDGES OF THE INFRARED BINS.
   !     FOR THE CURRENT MODEL SETUP, WAVE BINS 11 AND 12 ARE REVERSED
   !     IN ORDER, THAT IS 12 PRECEEDS 11. THEREFORE, CROSS SECTIONS,
   !     WEIGHTS, REFRACTIVE INDICIES ETC FOR BINS 11 AND 12 IN DATA
   !     STATEMENTS MUST BE REVERSED ALSO. THIS IS DONE FOR HISTORICAL
   !     REASONS.
   !
   !      DATA WAVE / 0.256, 0.280, 0.296,0.319,0.335,0.365,0.420,0.482,
   !     1     0.598, 0.690, 0.762, 0.719, 0.813, 0.862, 0.926, 1.005,
   !     2     1.111, 1.333, 1.562, 1.770, 2.051, 2.210, 2.584, 3.284,
   !     3     3.809, 4.292,
   !     4     4.546, 4.878, 5.128, 5.405, 5.714, 6.061, 6.452, 6.897,
   !     5     7.407, 8.333, 9.009, 10.309, 12.500, 13.889, 16.667,
   !     6     20.000, 26.316, 35.714, 62.50     /
   !
   real :: wave(nwave+1)
   !
   !     SOLAR FLUXES ( W/M**2)
   !      DATA SOLFX  /  4.1712E0, 2.5074E0, 1.2024E1, 1.7296E1, 1.2299E1,
   !     1        5.6975E1, 1.0551E2, 1.3250E2, 2.7804E2, 2.8636E1,
   !     2        5.9268E1, 5.0747E1, 5.7410E1, 4.3280E1, 7.4598E1,
   !     3        5.2732E1, 8.6900E1, 1.2126E2, 2.5731E1, 6.0107E1,
   !     4        1.8400E1, 9.5952E0, 3.5664E1, 1.2764E1, 4.0354E0,
   !     5        4.5364E0             /
   !
   !!     SOLAR FLUXES ( W/M**2)
   real :: solfx(nsol)
  
   logical :: lmie = .false.
  
   !
   !     HERE ARE THE CROSS SECTIONS FOR VARIOUS GASES. THERE ARE NWAVE
   !     OF THESE. A IS CROSS SECTION, W IS WEIGHT, PS IS PRESSURE SCALE.
   !
   !     ***********************
   !     *  DATA FOR SOLAR     *
   !     ***********************
   !
   !     UNITS ARE (CM**2)/GM
   !srf - inclusao da letra X no nome para eliminar bug
   !      DATA (XAH2O(I),I=1,77)  /      14*0.0, 0.0000, 0.1965, 9.2460,
   !
   real ::  xah2o(nsolp)
   !
   !      UNITS ARE (CM AMAGAT)
   !       DATA (XACO2(I),I=1,77)  /
   !     1       34*0.0,  0.0,    0.0035, 0.1849, 4*0.,   0.0,
  
   real ::  xaco2(nsolp)
   !
   !     UNITS ARE (CM AMAGAT)
   !      DATA (XAO2(I),I=1,77)   /
   !     1      10*0.0,  0.00, 0.00, 0.0001, 0.0022, 63*0.0  /
 
   real :: xao2(nsolp)
 
   !
   !     UNITS ARE (CM AMAGAT)
   !      DATA (XAO3(I),I=1,77)   /
   !     1      260.0, 100.9, 11.93, 0.7370, 0.0872, 0.0, 0.0,
   !     2      0.0, 0.1180, 0.0, 67*0.0   /
 
   real :: xao3(nsolp)
  
   real,dimension(ntotal) :: ta
   real,dimension(ntotal) :: tb
   real,dimension(ntotal) :: wa
   real,dimension(ntotal) :: wb
   real,dimension(ntotal) :: ga
   real,dimension(ntotal) :: gb
   real,dimension(ntotal) :: tia
   real,dimension(ntotal) :: tib
   real,dimension(ntotal) :: wia
   real,dimension(ntotal) :: wib
   real,dimension(ntotal) :: gia
   real,dimension(ntotal) :: gib
   real,dimension(ntotal) :: alpha
   real,dimension(ntotal) :: gama
   !kml2
   !real :: caseE(9,nwave+1)
   !real :: caseW(9,nwave+1)
   !real :: caseG(9,nwave+1)
   real :: caseE(9,nwave)
   real :: caseW(9,nwave)
   real :: caseG(9,nwave)

   ! DEFINED IN 'OPPROP'
   real :: wot
   real :: got
   real, allocatable :: ptempg(:)
   real, allocatable :: ptempt(:)
   !REAL, allocatable :: g0(:,:)
   !REAL, allocatable :: opd(:,:)
   !REAL, allocatable :: ptemp(:,:)
   !REAL, allocatable :: taul(:,:)

   real, allocatable :: tauh2o(:,:)
   real, allocatable :: taus(:,:)
   real, allocatable :: taua(:,:)
   real, allocatable :: g01(:,:)
   real, allocatable :: ug0(:,:)
   real, allocatable :: utaul(:,:)
   !REAL, allocatable :: w0(:,:)
   real, allocatable :: uw0(:,:)
   !REAL, allocatable :: uopd(:,:)

   ! DEFINED IN 'TWOSTR'
   real, allocatable :: u1s(:)
   real, allocatable :: u1i(:)
   real, allocatable :: acon(:,:)
   !REAL, allocatable :: ak(:,:)
   real, allocatable :: bcon(:,:)
   !REAL, allocatable :: b1(:,:)
   !REAL, allocatable :: b2(:,:)
   !REAL, allocatable :: ee1(:,:)
   !REAL, allocatable :: em1(:,:) 
   !REAL, allocatable :: em2(:,:)
   !REAL, allocatable :: el1(:,:)
   !REAL, allocatable :: el2(:,:)
   !REAL, allocatable :: gami(:,:)
   !REAL, allocatable :: af(:,:)
   !REAL, allocatable :: bf(:,:)
   !REAL, allocatable :: ef(:,:)
 
   ! DEFINED IN 'ADD'
   real, allocatable :: sfcs(:)
   !REAL, allocatable :: b3(:,:)
   !REAL, allocatable :: ck1(:,:)
   !REAL, allocatable :: ck2(:,:)
   !REAL, allocatable :: cp(:,:)
   !REAL, allocatable :: cpb(:,:)

   real, allocatable :: cm(:,:)
   !REAL, allocatable :: cmb(:,:)
   real, allocatable :: direct(:,:)
   real, allocatable :: ee3(:,:)
   real, allocatable :: el3(:,:)
   !REAL, allocatable :: fnet(:,:)
   !REAL, allocatable :: tmi(:,:)
   real, allocatable :: as(:,:)
   real, allocatable :: df(:,:)
   real, allocatable :: ds(:,:)
   real, allocatable :: xk(:,:)

   ! DEFINED IN 'NEWFLUX1'
   real, allocatable :: weit(:)
   !REAL, allocatable :: direc(:,:)
   !REAL, allocatable :: directu(:,:)
   !REAL, allocatable :: slope(:,:)
   !REAL, allocatable :: dintent(:,:,:)
   !REAL, allocatable :: uintent(:,:,:)
   !REAL, allocatable :: tmid(:,:)
   !REAL, allocatable :: tmiu(:,:)
 
   ! printed in 'radout' (defined in 'radtran')
   real :: tslu
   real :: tsld
   real :: alb_tot
   real :: tiru
   real, allocatable :: firu(:)
   real, allocatable :: firn(:)
   real, allocatable :: fslu(:)
   real, allocatable :: fsld(:)
   real, allocatable :: fsln(:)
   real, allocatable :: alb_toa(:)
   real, allocatable :: fupbs(:)
   real, allocatable :: fdownbs(:)
   real, allocatable :: fnetbs(:)
   real, allocatable :: fupbi(:)
   real, allocatable :: fdownbi(:)
   real, allocatable :: fnetbi(:)
   real, allocatable :: qrad(:,:,:)

   real :: alb_tomi
   real :: alb_toai

   character(LEN=256) :: raddatfn
   integer :: rdatfnum=22  !0
   logical :: rad_data_not_read

   contains

   subroutine initial_definitions_globrad()

     use mem_aerad, only: &
          nz_rad,         &  !INTENT(IN)
          nbin,           &  !INTENT(IN)
          nir                !INTENT(IN)

     implicit none

     ! Defining Variables:
     nvert   = nz_rad
     nrad    = nbin 
     nlayer  = nvert+1
     ndbl    = 2*nlayer
     nradver = nrad*nvert
     nradlay = nrad*nlayer
     ncount = nhigh - nlow
     
     rdatfnum = 22
     rad_data_not_read = .true.

     ! Allocating arrays:
     allocate(o3mix(nlayer))
     allocate(rmin(ngroup))
     allocate(r(nrad,ngroup))
     allocate(is_grp_ice(ngroup))
     allocate(core_rad(nrad,ngroup))
     allocate(coreup_rad(nrad,ngroup))
     allocate(p(nvert))
     allocate(t(nvert))
     allocate(q(nvert))
     allocate(heati(nlayer))
     allocate(heats(nlayer))
     allocate(heat(nlayer))
     allocate(sflx(nsol))
     allocate(wvln(nsol))
     allocate(emis(ntotal))
     !ALLOCATE(rsfx(ntotal)
     allocate(ltemp(ntotal))
     allocate(sol(ntotal))
     allocate(tauray(ntotal))
     !ALLOCATE(gcld(  ntotal,nlayer)))
     allocate(gol(ntotal,nlayer))
     allocate(wol(ntotal,nlayer))
     allocate(nprobi(nwave,2))
     allocate(aco2(ntotal))
     allocate(ah2o(ntotal))
     allocate(ao2(ntotal))
     allocate(ao3(ntotal))
     !ALLOCATE(paco2(ntotal,nlayer))
     !ALLOCATE(pah2o(ntotal,nlayer))
     !ALLOCATE(pao2(ntotal,nlayer))
     !ALLOCATE(pao3(ntotal,nlayer))
     allocate(planck(nir+1,ncount))
     !ALLOCATE(taugas(ntotal,nlayer))
     allocate(xsecta(nrad,ngroup))
     allocate(rup(nrad,ngroup))
     allocate(qscat(nrad,ngroup,nwave))
     allocate(qbrqs(nrad,ngroup,nwave))
     allocate(rdqext(nrad,ngroup,nwave))
     allocate(co2(nlayer))
     allocate(rdh2o(nlayer))
     allocate(o2(nlayer))
     allocate(o3(nlayer))
     !allocate(caer(nrad,nlayer,ngroup))
     !allocate(press(nlayer))
     allocate(pbar(nlayer))
     !allocate(dpg(nlayer))
     allocate(tt(nlayer))
     !allocate(y3(ntotal,ngauss,nlayer))
     allocate(ptempg(ntotal))
     allocate(ptempt(ntotal))
     !ALLOCATE(g0(ntotal,nlayer))
     !ALLOCATE(opd(ntotal,nlayer))
     !ALLOCATE(ptemp(ntotal,nlayer))
     !ALLOCATE(taul(ntotal,nlayer))
     allocate(tauh2o(ntotal,nlayer))
     allocate(taus(nwave,nlayer))
     allocate(taua(nwave,nlayer))
     allocate(g01(nwave,nlayer))
     allocate(ug0(ntotal,nlayer))
     allocate(utaul(ntotal,nlayer))
     !allocate(w0(ntotal,nlayer))
     allocate(uw0(ntotal,nlayer))
     !allocate(uopd(ntotal,nlayer))
     allocate(u1s( ntotal))
     allocate(u1i( ntotal))
     allocate(acon(ntotal,nlayer))
     !ALLOCATE(ak(ntotal,nlayer)))
     allocate(bcon(ntotal,nlayer))
     !ALLOCATE(b1(  ntotal,nlayer))
     !ALLOCATE(b2(  ntotal,nlayer))
     !ALLOCATE(ee1( ntotal,nlayer))
     !ALLOCATE(em1(ntotal,nlayer) )
     !ALLOCATE(em2(ntotal,nlayer))
     !ALLOCATE(el1( ntotal,nlayer))
     !ALLOCATE(el2(ntotal,nlayer))
     !ALLOCATE(gami(ntotal,nlayer))
     !ALLOCATE(af(ntotal,ndbl))
     !ALLOCATE(bf(ntotal,ndbl))
     !ALLOCATE(ef(ntotal,ndbl))
     allocate(sfcs(ntotal))
     !ALLOCATE(b3(  ntotal,nlayer))
     !ALLOCATE(ck1(   ntotal,nlayer))
     !ALLOCATE(ck2( ntotal,nlayer))
     !ALLOCATE(cp(    ntotal,nlayer))
     !ALLOCATE(cpb( ntotal,nlayer))
     allocate(cm(ntotal,nlayer))
     !allocate(cmb( ntotal,nlayer))
     allocate(direct(ntotal,nlayer))
     allocate(ee3(ntotal,nlayer))
     allocate(el3(ntotal,nlayer))
     !allocate(fnet(ntotal,nlayer))
     !allocate(tmi(ntotal,nlayer))
     allocate(as(ntotal,ndbl))
     allocate(df(ntotal,ndbl))
     allocate(ds(ntotal,ndbl))
     allocate(xk(ntotal,ndbl))
     allocate(weit(ntotal))
     !ALLOCATE(direc(ntotal,nlayer))
     !ALLOCATE(directu(ntotal,nlayer))
     !ALLOCATE(slope(ntotal,nlayer))
     !ALLOCATE(dintent(ntotal,ngauss,nlayer))
     !ALLOCATE(uintent(ntotal,ngauss,nlayer))
     !ALLOCATE(tmid(ntotal,nlayer))
     !ALLOCATE(tmiu(ntotal,nlayer))
     allocate(firu(nir))
     allocate(firn(nir))
     allocate(fslu(nsol))
     allocate(fsld(nsol))
     allocate(fsln(nsol))
     allocate(alb_toa(nsol))
     allocate(fupbs(nlayer))
     allocate(fdownbs(nlayer))
     allocate(fnetbs(nlayer))
     allocate(fupbi(nlayer))
     allocate(fdownbi(nlayer))
     allocate(fnetbi(nlayer))
     allocate(qrad(ngroup,nlayer,nrad))

   end subroutine initial_definitions_globrad

   ! ***************************************************************************

   subroutine final_definitions_globrad()

     use mem_aerad, only: &
          nz_rad              !INTENT(IN)

     implicit none

     ! Deallocating arrays:
     deallocate(o3mix)
     deallocate(rmin)
     deallocate(r)
     deallocate(is_grp_ice)
     deallocate(core_rad)
     deallocate(coreup_rad)
     deallocate(p)
     deallocate(t)
     deallocate(q)
     deallocate(heati)
     deallocate(heats)
     deallocate(heat)
     deallocate(sflx)
     deallocate(wvln)
     deallocate(emis)
     !deALLOCATE(rsfx
     deallocate(ltemp)
     deallocate(sol)
     deallocate(tauray)
     !deALLOCATE(gcld)
     deallocate(gol)
     deallocate(wol)
     deallocate(nprobi)
     deallocate(aco2)
     deallocate(ah2o)
     deallocate(ao2)
     deallocate(ao3)
     !deALLOCATE(paco2)
     !deALLOCATE(pah2o)
     !deALLOCATE(pao2)
     !deALLOCATE(pao3)
     deallocate(planck)
     !deALLOCATE(taugas)
     deallocate(xsecta)
     deallocate(rup)
     deallocate(qscat)
     deallocate(qbrqs)
     deallocate(rdqext)
     deallocate(co2)
     deallocate(rdh2o)
     deallocate(o2)
     deallocate(o3)
     !deallocate(caer)
     !deallocate(press)
     deallocate(pbar)
     !deallocate(dpg)
     deallocate(tt)
     !deallocate(y3)
     deallocate(ptempg)
     deallocate(ptempt)
     !deALLOCATE(g0)
     !deALLOCATE(opd)
     !deALLOCATE(ptemp)
     !deALLOCATE(taul)
     deallocate(tauh2o)
     deallocate(taus)
     deallocate(taua)
     deallocate(g01)
     deallocate(ug0)
     deallocate(utaul)
     !deallocate(w0)
     deallocate(uw0)
     !deallocate(uopd)
     deallocate(u1s)
     deallocate(u1i)
     deallocate(acon)
     !deALLOCATE(ak)
     deallocate(bcon)
     !deALLOCATE(b1)
     !deALLOCATE(b2)
     !deALLOCATE(ee1)
     !deALLOCATE(em1)
     !deALLOCATE(em2)
     !deALLOCATE(el1)
     !deALLOCATE(el2)
     !deALLOCATE(gami)
     !deALLOCATE(af)
     !deALLOCATE(bf)
     !deALLOCATE(ef)
     deallocate(sfcs)
     !deALLOCATE(b3)
     !deALLOCATE(ck1)
     !deALLOCATE(ck2)
     !deALLOCATE(cp)
     !deALLOCATE(cpb)
     deallocate(cm)
     !deallocate(cmb)
     deallocate(direct)
     deallocate(ee3)
     deallocate(el3)
     !deallocate(fnet)
     !deallocate(tmi)
     deallocate(as)
     deallocate(df)
     deallocate(ds)
     deallocate(xk)
     deallocate(weit)
     !deALLOCATE(direc)
     !deALLOCATE(directu)
     !deALLOCATE(slope)
     !deALLOCATE(dintent)
     !deALLOCATE(uintent)
     !deALLOCATE(tmid)
     !deALLOCATE(tmiu)
     deallocate(firu)
     deallocate(firn)
     deallocate(fslu)
     deallocate(fsld)
     deallocate(fsln)
     deallocate(alb_toa)
     deallocate(fupbs)
     deallocate(fdownbs)
     deallocate(fnetbs)
     deallocate(fupbi)
     deallocate(fdownbi)
     deallocate(fnetbi)
     deallocate(qrad)

   end subroutine final_definitions_globrad

   ! **************************************************************************

   subroutine master_read_carma_data()

     use mem_radiate, only: ISWRTYP, ILWRTYP ! Intent(in)

     implicit none

     ! Local Variables
     integer, parameter :: input_unit=22
     integer :: n

     namelist /rad/ &
          o3mixp,pj,ako3,akco2,akh2o,contnm,gangle, &
          gratio,gweight,weight,treal,ttmag,nprob,  &
          pso2,pso3,psh2o,psco2,wave,solfx,xah2o, &
          xaco2,xao2,xao3,ta,tb,wa,wb,ga,gb,tia,tib, &
          wia,wib,gia,gib,alpha,gama,caseE,caseW,caseG

     ! Check if CARMA Radiation is selected
     if (ISWRTYP/=4 .and. ILWRTYP/=4) return
     
! IN THE OLD METHOD< ONE READS IN THE PARAMETERS IN THE CARMA FILE
! WE WERE HAVING TROUBLE READING IT IN     
!     write (unit=*,fmt='(a)') 'Reading CARMA settings...'
!     open (unit=input_unit,file=raddatfn,status='old')
!     read (unit=input_unit,nml=rad)
!     close(unit=input_unit)

     o3mixp= (/5.3E-08,     5.5E-08,      6.5E-08,     2.2E-07,     1.4E-06,     1.14E-05/)

     pj=(/     1.0    ,     0.75   ,      0.50   ,     0.25   ,     0.10   ,     0.01/)

     ako3(1,:)=  (/12103.15537, 12402.63363,  12815.75276, 13293.58735, 12792.67732,  5263.93060/)
     ako3(2,:)=  (/ 4073.95522,  3824.69235,   3430.8699 ,  2683.45418,  1705.58659,   294.00564/)
     ako3(3,:)=  (/  256.02950,   246.52991,    229.39518,   189.37447,   123.25784,    19.16440/)
     ako3(4,:)=  (/    0.02424,     0.02417,     0.02402 ,     0.02357,     0.02223,     0.00373/)
     
     akco2(1,:)= (/   21.55629,    19.04724,    15.82831,    11.24202,      6.87763,     1.93565/)
     akco2(2,:)= (/    1.41477,     1.19470,     0.94231,     0.63257,      0.38015,     0.06712/)
     akco2(3,:)= (/    0.02091,     0.01822,     0.01471,     0.00950,      0.00443,     0.00784/)
     akco2(4,:)= (/ 4285.18491,  4190.41876,  3956.55409,  3319.57528,   2275.73601,   527.26813/)
     akco2(5,:)= (/  490.02297,   420.10700,   331.10330,   211.02566,    109.50739,    18.39552/)
     akco2(6,:)= (/   52.24044,    42.14958,    31.06085,    18.17948,      8.80769,     1.40437/)
     
     akh2o(01,:)=(/    0.02080,     0.01550,     0.01040,     0.00510,      0.00200,     0.00062/)
     akh2o(02,:)=(/    0.17070,     0.12910,     0.08630,     0.04300,      0.01710,     0.00043/)
     akh2o(03,:)=(/    3.69350,     3.03920,     2.18270,     1.18620,      0.48190,     0.00012/)
     akh2o(04,:)=(/    0.09550,     0.07170,     0.04775,     0.02390,      0.00970,     0.00096/)
     akh2o(05,:)=(/    0.56670,     0.42490,     0.28390,     0.14190,      0.05620,     0.00565/)
     akh2o(06,:)=(/    4.42380,     3.37860,     2.27150,     1.14360,      0.45980,     0.04582/)
     akh2o(07,:)=(/   52.2782 ,    46.7368 ,    37.4543 ,    22.1443 ,      9.48870,     0.96239/)
     akh2o(08,:)=(/    0.74700,     0.55860,     0.37410,     0.18640,      0.07480,     0.00757/)
     akh2o(09,:)=(/    6.21910,     4.71170,     3.17460,     1.57760,      0.63070,     0.06400/)
     akh2o(10,:)=(/  108.8498 ,    93.64720,    70.7601 ,    40.4311 ,     16.7743 ,     1.64448/)
     akh2o(11,:)=(/    5.32480,     4.02140,     2.69230,     1.33950,      0.53460,     0.05812/)
     akh2o(12,:)=(/   37.4911 ,    28.7735 ,    19.3551 ,     9.8670 ,      3.93660,     0.48536/)
     akh2o(13,:)=(/  399.4563 ,   372.4726 ,   317.0208 ,   199.0702 ,     91.07190,     9.51138/)
     akh2o(14,:)=(/   19.5458 ,    14.6823 ,     9.89610,     4.88830,      1.96260,     0.19703/)
     akh2o(15,:)=(/  129.8270 ,   100.9301 ,    68.2980 ,    34.9858 ,     13.9141 ,     1.39263/)
     akh2o(16,:)=(/ 1289.8795 ,  1225.3730 ,  1077.8933 ,   713.0905 ,    338.1374 ,    34.83768/)
     akh2o(17,:)=(/   10.1830 ,     7.64440,     5.09240,     2.54900,      1.04120,     0.10272/)
     akh2o(18,:)=(/   61.2038 ,    46.4646 ,    31.2440 ,    15.7152 ,      6.24550,     0.62696/)
     akh2o(19,:)=(/  363.8096 ,   297.8458 ,   214.1972 ,   112.6198 ,     45.6958 ,     4.55650/)
     akh2o(20,:)=(/ 2005.95   ,  2053.91   ,  1991.06   ,  1561.74   ,    825.730  ,    89.7681 /)
     akh2o(21,:)=(/   15.3380 ,    11.5228 ,     8.5296 ,     3.8592 ,      1.54910,     0.15449/)
     akh2o(22,:)=(/   72.4480 ,    54.6480 ,    32.2028 ,    18.2840 ,      7.31640,     0.73264/)
     akh2o(23,:)=(/  440.2140 ,   352.1620 ,   512.833  ,   128.293  ,     51.6640 ,     5.14812/)
     akh2o(24,:)=(/ 3343.51   ,  3347.37   ,   512.833  ,   233.720  ,   1182.99   ,   124.7161 /)
     akh2o(25,:)=(/    3.76110,     2.82540,     1.88200,     0.94320,      0.37750,     0.03777/)
     akh2o(26,:)=(/   29.5500 ,    22.4360 ,    15.1239 ,     7.57360,      3.02760,     0.30409/)
     akh2o(27,:)=(/  424.620  ,   379.480  ,   304.175  ,   180.650  ,     78.0440 ,     7.94202/)
     akh2o(28,:)=(/    1.25230,     0.93840,     0.62750,     0.31300,      0.12450,     0.01251/)
     akh2o(29,:)=(/   27.4300 ,    22.1200 ,    15.7100 ,     8.2700 ,      3.37560,     0.34112/)
     akh2o(30,:)=(/    0.14650,     0.11010,     0.07330,     0.03670,      0.01480,     0.01476/)
     akh2o(31,:)=(/    4.95E-8,     4.95E-8,     4.95E-8,     4.95E-8,      4.95E-8,     4.95E-8/)
     akh2o(32,:)=(/    6.06E-8,     6.06E-8,     6.06E-8,     6.06E-8,      6.06E-8,     6.06E-8/)
     akh2o(33,:)=(/    1.12E-7,     1.12E-7,     1.12E-7,     1.12E-7,      1.12E-7,     1.12E-7/)
     akh2o(34,:)=(/    1.32700,     1.38470,     0.97515,     0.50750,      0.20570,     0.02090/)
     akh2o(35,:)=(/    0.07038,     0.05380,     0.03595,     0.01790,      0.00720,     0.00068/)
     akh2o(36,:)=(/    0.00782,     0.00590,     0.00393,     0.00190,      0.00078,     0.00002/)
     akh2o(37,:)=(/    0.00128,     0.00096,     0.00642,     0.00032,      0.00013,     0.00010/)
     akh2o(38,:)=(/    3.00300,     2.91330,     1.97760,     1.00080,      0.40170,     0.0402 /)
     akh2o(39,:)=(/    0.13090,     0.09870,     0.06580,     0.03290,      0.00131,     0.00131/)
     akh2o(40,:)=(/    0.01379,     0.01350,     0.00690,     0.00350,      0.00014,     0.00014/)
     akh2o(41,:)=(/   29.2600 ,    27.7800 ,    19.0800 ,     9.7400 ,      3.92000,     0.39310/)
     akh2o(42,:)=(/    1.27900,     0.96860,     0.64580,     0.32290,      0.12910,     0.01290/)
     akh2o(43,:)=(/    0.13480,     0.10150,     0.06770,     0.03380,      0.01350,     0.00135/)
     akh2o(44,:)=(/  716.500  ,   666.670  ,   491.250  ,   266.300  ,    109.670  ,    11.2050 /)
     akh2o(45,:)=(/   39.7800 ,    29.7300 ,    19.8800 ,     9.9500 ,      3.98000,     0.37610/)
     akh2o(46,:)=(/    4.47600,     3.35300,     2.23640,     1.11900,      0.44740,     0.00996/)
     akh2o(47,:)=(/    0.73960,     0.55410,     0.36940,     0.18460,      0.07390,     0.06010/)
     akh2o(48,:)=(/ 5631.00   ,  6090.99   ,  4475.54   ,  2422.79   ,    998.340  ,   100.540  /)
     akh2o(49,:)=(/  414.800  ,   309.620  ,   206.840  ,   103.450  ,     41.3600 ,     4.13620/)
     akh2o(50,:)=(/   53.4600 ,    40.2600 ,    26.8600 ,    13.4300 ,      5.37520,     0.53760/)
     akh2o(51,:)=(/    9.56300,     7.17130,     4.78020,     2.38970,      0.95580,     0.09560/)
     akh2o(52,:)=(/ 2779.00   ,  2844.55   ,  1937.23   ,   982.710  ,    394.850  ,    39.5000 /)
     akh2o(53,:)=(/  134.600  ,   108.410  ,    72.2400 ,    36.1100 ,     14.4000 ,     1.44600/)
     akh2o(54,:)=(/    0.008995,    8.62480,     5.75790,     2.8800 ,      1.15300,     0.10640/)
     
     contnm= (/  0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                0.      ,    0.     ,     0.     ,     0.     ,      0.     ,     0.      ,&
                2.e-7   ,    2.e-7  ,     2.e-7  ,     2.e-7  ,      2.e-7  ,     2.e-7   ,&
                2.e-7   ,    2.e-7  ,     2.e-7  ,     2.e-7  ,      2.e-7  ,     2.e-7   ,&
                4.266E-7,    4.266E-7,    4.266E-7,    4.266E-7,     4.266E-7,    4.266E-7,&
                4.266E-7,    4.266E-7,    4.266E-7,    9.65E-7 ,     9.65E-7 ,    9.65E-7 ,&
                2.423E-6,    2.423E-6,    2.423E-6,    2.423E-6,     5.765E-6,    5.765E-6,&
                5.765E-6,    5.765E-6,    1.482E-5,    1.482E-5,     1.482E-5 /)

     gangle= (/    0.2123405382, 0.5905331356, 0.9114120405 /)

     gratio= (/    0.4679139346, 0.3607615730, 0.1713244924 /)

     gweight= (/   0.0698269799, 0.2292411064, 0.2009319137 /)
     
     weight= (/  1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     , &
                1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     , 1.00     ,&
                0.8471   , 0.1316   , 0.0158   , 0.0055   , 0.7825   , 0.19240  , 0.0251   , 0.8091   ,&
                0.1689   , 0.0221   , 1.0000   , 0.41070  , 0.4885   , 0.0751   , 0.0258   , 1.0000   ,&
                0.6385   , 0.29660  , 0.0484   , 0.0164   , 0.2964   , 0.3854   , 0.2583   , 0.05990  ,&
                0.9486   , 0.0455   , 0.0059   , 0.2962   , 0.3234   , 0.25880  , 0.1216   , 0.5866   ,&
                0.3524   , 0.0449   , 0.0160   , 1.00000  , 2.2823E-2, 3.8272E-3, 3.1557E-3, 2.7938E-3,&
                2.3677E-1, 3.9705E-2, 3.2738E-2, 2.8984E-2, 1.8182E-1, 3.0489E-2, 2.5139E-2, 2.2256E-2,&
                1.7783E-1, 2.9820E-2, 2.4587E-2, 2.1768E-2, 8.0862E-2, 1.3560E-2, 1.1180E-2, 9.8984E-3,&
                0.3807   , 0.3416   , 0.2256   , 0.0522   , 1.0000   , 0.3908   , 0.1383   , 0.1007   ,&
                0.0967   , 0.0984   , 0.1751,                                                           &
                !Data for infrared
                0.3710   , 0.4400   , 0.1890   , 0.3070   , 0.3980   , 0.2050   , 0.0900   , 0.4030   ,&
                0.4150   , 0.1820   , 0.3770   , 0.4330   , 0.1900   , 0.3100   , 0.4580   , 0.2320   ,&
                0.3160   , 0.3980   , 0.1850   , 0.1010   , 0.2030   , 0.4010   , 0.2720   , 0.1240   ,&
                0.3820   , 0.4240   , 0.1940   , 0.4120   , 0.1800   , 0.4080   , 1.0000   , 0.2220   ,&
                0.3400   , 0.1400   , 0.2980   , 1.0000   , 0.0117   , 0.0311   , 0.0615   , 0.0458   ,&
                0.0176   , 0.0468   , 0.0927   , 0.0689   , 0.0487   , 0.1292   , 0.2558   , 0.1903   ,&
                0.0242   , 0.0633   , 0.0665   , 0.0589   , 0.1541   , 0.1620   , 0.0740   , 0.1936   ,&
                0.2035   , 0.1570   , 0.4100   , 0.4330   , 0.0810   , 0.2080   , 0.4090   , 0.3020   ,&
                0.0990   , 0.2200   , 0.4040   , 0.2770   , 0.3670   , 0.5870   , 0.0460               /)
                
     treal(1,:)=  (/   1.38    , 1.37    , 1.365   , 1.36    , 1.357   ,  &
                1.353   , 1.342   , 1.3401  , 1.3372  , 1.336   ,&
                1.3355  , 1.3342  , 1.333   , 1.3323  , 1.3322  ,&
                1.332   , 1.332   , 1.332   , 1.331   , 1.330   ,&
                1.329   , 1.328   , 1.327   , 1.323   , 1.319   ,&
                1.313   , 1.305   , 1.295   , 1.252   , 1.455   ,&
                1.362   , 1.334   , 1.326   , 1.320   , 1.308   ,&
                1.283   , 1.278   , 1.313   , 1.326   , 1.310   , &
                1.293   , 1.270   , 1.227   , 1.164   , 1.173   , &
                1.287   , 1.415   , 1.508   , 1.541   , 1.669 /)

treal(2,:)=   (/  1.3480E+00,  1.3407E+00,  1.3353E+00,  1.3307E+00,  1.3275E+00,&
                1.3231E+00,  1.3177E+00,  1.3165E+00,  1.3147E+00,  1.3140E+00,&
                1.3133E+00,  1.3115E+00,  1.3098E+00,  1.3080E+00,  1.3077E+00,&
                1.3071E+00,  1.3065E+00,  1.3056E+00,  1.3047E+00,  1.3038E+00,&
                1.3028E+00,  1.3014E+00,  1.2997E+00,  1.2955E+00,  1.2906E+00,&
                1.2837E+00,  1.2717E+00,  1.2629E+00,  1.1815E+00,  1.4310E+00,&
                1.3874E+00,  1.3473E+00,  1.3427E+00,  1.3288E+00,  1.3140E+00,  &
                1.2972E+00,  1.2908E+00,  1.3155E+00,  1.3186E+00,  1.3189E+00,  &
                1.3125E+00,  1.2848E+00,  1.2268E+00,  1.1921E+00,  1.4906E+00,  &
                1.5588E+00,  1.5143E+00,  1.4427E+00,  1.3047E+00,  1.4859E+00 /)

ttmag(1,:)=   (/  1.e-15  , 1.e-15  , 1.e-15  , 1.e-15  , 1.e-15  ,&
                1.e-15  , 1.e-15  , 1.e-15  , 1.e-15  , 1.e-15  ,&
                1.e-15  , 1.e-15  , 1.e-15  , 2.70E-08, 1.82E-8 ,&
                2.11E-8,  1.68E-07, 6.66E-08, 1.24E-07, 2.94E-07,&
                8.77E-07, 3.06E-06, 2.05E-06, 2.39E-05, 1.20E-04,&
                1.18E-04, 6.79E-04, 3.51E-04, 2.39E-03, 0.0442  ,&
                0.00339 , 0.00833 , 0.0139  , 0.0125  , 0.011   ,&
                0.015   , 0.075   , 0.086   , 0.039   , 0.035   ,&
                0.035   , 0.038   , 0.051   , 0.161   , 0.308   ,&
                0.39    , 0.42    , 0.395   , 0.373   , 0.5     /)

ttmag(2,:)=  (/   8.0822E-09,  6.7516E-09,  5.7565E-09,  4.8780E-09,  4.2693E-09,&
                3.4207E-09,  2.2612E-09,  2.09E-09  ,  1.84E-09  ,  1.7429E-09,&
                7.5115E-09,  2.64E-09  ,  5.12E-09  ,  2.4450E-08,  1.89E-08  ,&
                2.08E-08  ,  3.8345E-08,  7.5497E-08,  1.3765E-07,  2.3306E-07,&
                5.2670E-07,  1.7241E-06,  2.2288E-06,  7.3358E-05,  4.8415E-04,&
                2.6270E-04,  1.2123E-03,  3.0644E-04,  2.7738E-02,  2.7197E-01,&
                7.5589E-03,  1.6397E-02,  1.9980E-02,  1.2469E-02,  1.4622E-02,&
                2.5275E-02,  5.4226E-02,  6.5501E-02,  5.6727E-02,  5.4499E-02,&
                4.6806E-02,  4.0056E-02,  4.9961E-02,  3.0257E-01,  3.6528E-01,&
                1.7601E-01,  8.6618E-02,  3.4573E-02,  8.5167E-02,  4.4443E-01 /)

nprob=  (/ 01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,&
         17,17,17,17,18,18,18,19,19,19,20,21,21,21,21,22,&
         23,23,23,23,24,24,24,24,25,25,25,26,26,26,26,27,&
         27,27,27,28,29,29,29,29,29,29,29,29,29,29,29,29,&
         29,29,29,29,29,29,29,29,30,30,30,30,31,32,32,32,&
         32,32,32,33,33,33,34,34,34,34,35,35,35,36,36,36,&
         37,37,37,38,38,38,38,39,39,39,39,40,40,40,41,41,&
         41,42,43,43,43,43,44,45,45,45,45,45,45,45,45,45,&
         45,45,45,46,46,46,46,46,46,46,46,46,47,47,47,48,&
         48,48,48,49,49,49,49,50,50,50                   /)

pso2=  (/   0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.75 , 0.75 , 0.75 , 0.75 , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  ,                                   &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  ,&
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0          /)

pso3=  (/   0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , & 
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  ,                                    &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0          /) 

psh2o=  (/  0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.54 , 0.54 , 0.54 , 0.54 , &
          0.54 , 0.54 , 0.0  , 0.54 , 0.54 , 0.54 , 0.54 , 0.0  , &
          0.52 , 0.52 , 0.52 , 0.52 , 0.44 , 0.44 , 0.44 , 0.44 , &
          0.0  , 0.0  , 0.0  , 0.62 , 0.62 , 0.62 , 0.62 , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.60 , 0.60 , 0.60 , 0.60 , &
          0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , &
          0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , 0.60 , &
          0.60 , 0.60 , 0.60 , 0.60 , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  ,                                    &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0           /)

psco2=  (/ 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.82 , &
          0.82 , 0.82 , 0.82 , 0.0  , 0.88 , 0.88 , 0.88 , 0.88 , &
          0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , &
          0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , 0.88 , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.93 , 0.93 , 0.93 , &
          0.93 , 0.93 , 0.93 ,                                    &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , &
          0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0  , 0.0           /)

wave= (/ 0.256,  0.280,  0.296,  0.319,  0.335,  0.365,  0.420,  0.440,&
        0.470,  0.482,  0.500,  0.550,  0.598,  0.660,  0.670,  0.690,&
        0.762,  0.719,  0.813,  0.862,  0.926,  1.005,  1.111,  1.333,&
        1.562,  1.770,  2.051,  2.210,  2.584,  3.284,  3.809,  4.292,&
        4.546,  4.878,  5.128,  5.405,  5.714,  6.061,  6.452,  6.897,&
        7.407,  8.333,  9.009, 10.309, 12.500, 13.889, 16.667, 20.000,&
       26.316, 35.714, 62.50                                          /)

solfx= (/ 4.1712E0, 2.5074E0, 1.2024E1, 1.7296E1, 1.2299E1, 5.6975E1, &
        6.6E1   , 4.5725E1, 4.2147E1, 2.9169E1, 6.4328E1, 9.225E1 , &
        9.7647E1, 5.467E1 , 2.3085E1, 2.9665E1, 5.9268E1, 5.0747E1, &
        5.7410E1, 4.3280E1, 7.4598E1, 5.2732E1, 8.6900E1, 1.2126E2, &
        2.5731E1, 6.0107E1, 1.8400E1, 9.5952E0, 3.5664E1, 1.2764E1, &
        4.0354E0, 4.5364E0                                          /)

xah2o= (/ 0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.1765 ,   9.2460 ,   0.0000 ,&
        0.1765 ,   9.2460 ,   0.0000 ,   0.0000 ,   0.2939 ,   0.5311 ,&
      113.40   ,   0.0000 ,   0.0000 ,   0.3055 ,   5.2180 , 113.00   ,&
        0.00   ,   0.3355 ,   5.5090 , 124.90   ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.3420 ,   7.1190 ,  95.740  ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.3012 ,   0.3012 ,   0.3012 ,   0.3012 ,&
        5.021  ,   5.021  ,   5.021  ,   5.021  ,  63.17   ,  63.17   ,&
       63.17   ,  63.17   , 699.1    , 699.1    , 699.1    , 699.1    ,&
        0.0    ,   6.3321 ,   5.336  , 123.4    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0                /)
                          
xaco2= (/ 0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0035 ,&
        0.1849 ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0032 ,   0.0705 ,   1.2980 ,   0.0    ,   0.0    ,   0.0077 ,&
        0.2027 ,   3.8160 ,   0.0000 ,   0.0077 ,   0.2027 ,   3.8160 ,&
        0.0000 ,   0.0077 ,   0.2027 ,   3.8160 ,   0.0000 ,   0.0077 ,&
        0.2027 ,   3.8160 ,   0.0000 ,   0.0077 ,   0.2027 ,   3.8160 ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0053 ,   0.0705 ,   0.6732 ,   6.2880 ,  83.900              /)

xao2= (/ 0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0001 ,   0.0022 ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0    ,&
        0.0    ,   0.0    ,   0.0    ,   0.0    ,   0.0                /)

xao3= (/ 260.0     , 100.9     , 11.93    , 0.7370 ,   0.0872 ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.01831,   0.069172, &
        0.1180  ,   0.016389,  0.010926, 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0    ,   0.0     , &
        0.0     ,   0.0     ,  0.0     , 0.0    ,   0.0  /)
	            


ta=   (/ 1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.500   ,  1.50,  &
        0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.70,  &
        0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.70,  &
        0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.70,  &
        0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.700   ,  0.24,  &
        0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.24,  &
        0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.24,  &
        0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.240   ,  0.27,  &
        0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.27,  &
        0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.27,  &
        0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.270   ,  0.27,  &
        0.270   ,  0.270   ,  0.270   ,  0.270   /)
        	   
tb=  (/  0.500   ,   0.500   ,   0.500   ,   0.500	,   0.500   ,   0.500, &
        0.500   ,   0.500   ,   0.500   ,   0.500	,   0.500   ,   0.500, &
        0.500   ,   0.500   ,   0.500   ,   0.500	,   0.780   ,   0.780, &
        0.780   ,   0.780   ,   0.780   ,   0.780	,   0.780   ,   0.780, &
        0.780   ,   0.780   ,   0.780   ,   0.780	,   0.780   ,   0.780, &
        0.780   ,   0.780   ,   0.780   ,   0.780	,   0.780   ,   0.780, &
        1.130   ,   1.130   ,   1.130   ,   1.130	,   1.130   ,   1.130, &
        1.130   ,   1.130   ,   1.130   ,   1.130	,   1.130   ,   1.130, &
        1.130   ,   1.130   ,   1.130   ,   1.130	,   2.   ,   2., &
        2.   ,   2.   ,   2.   ,   2.	,   2.   ,   2., &
        2.   ,   2.   ,   2.   ,   2.	,   2.   ,   2., &
        2.   ,   2.   ,   2.   ,   2.	,   2.   ,   2., &
        2.   ,   2.   ,   2.   ,   2.	,   2.   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.120, &
       -0.120   ,  -0.120   ,  -0.120   ,  -0.120	,  -0.120   ,  -0.008, &
       -0.008   ,  -0.008   ,  -0.008   ,  -0.008	,  -0.008   ,  -0.008, &
       -0.008   ,  -0.008   ,  -0.008   ,  -0.008	,  -0.008   ,  -0.008, &
       -0.008   ,  -0.008   ,  -0.008   ,  -0.008	,  -0.008   ,  -0.011, &
       -0.011   ,  -0.011   ,  -0.011   ,  -0.011	,  -0.011   ,  -0.011, &
       -0.011   ,  -0.011   ,  -0.011   ,  -0.011	,  -0.011   ,  -0.011, &
       -0.011   ,  -0.011   ,  -0.011   ,  -0.011	,  -0.011   ,  -0.011, &
       -0.011   ,  -0.011   ,  -0.011   ,  -0.011  /)


wa=  (/   5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7, &
        5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7, &
        5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  5.580e-7   ,  2.180e-5   ,  2.180e-5,  &
        2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5,  &      
        2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5,  &      
        2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5   ,  2.180e-5,  &      
        8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4,  &      
        8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4,  &      
        8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  8.550e-4   ,  1.940e-1   ,  1.940e-1,  &      
        1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1,  &      
        1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1,  &      
        1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1,  &      
        1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  1.940e-1   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110,  &      
        0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.110   ,  0.430,  &      
        0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.430,  &      
        0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.430,  &      
        0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.430   ,  0.740,  &      
        0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740,  &      
        0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740,  &      
        0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.740,  &      
        0.740   ,  0.740   ,  0.740   ,  0.74 /)


wb=   (/  -1.25e-7   ,   -1.25e-7   ,   -1.25e-7   ,   -1.25e-7	,   -1.25e-7   ,   -1.25e-7,&	   
        -1.25e-7   ,   -1.25e-7   ,   -1.25e-7   ,   -1.25e-7	,   -1.25e-7   ,   -1.25e-7,&	   
        -1.25e-7   ,   -1.25e-7   ,   -1.25e-7   ,   -1.25e-7	,   -2.25e-5   ,   -2.25e-5,&	  
        -2.25e-5   ,   -2.25e-5   ,   -2.25e-5   ,   -2.25e-5	,   -2.25e-5   ,   -2.25e-5,&	  
        -2.25e-5   ,   -2.25e-5   ,   -2.25e-5   ,   -2.25e-5	,   -2.25e-5   ,   -2.25e-5,&	  
        -2.25e-5   ,   -2.25e-5   ,   -2.25e-5   ,   -2.25e-5	,   -2.25e-5   ,   -2.25e-5,&	  
        -1.28e-3   ,   -1.28e-3   ,   -1.28e-3   ,   -1.28e-3	,   -1.28e-3   ,   -1.28e-3,&	  
        -1.28e-3   ,   -1.28e-3   ,   -1.28e-3   ,   -1.28e-3	,   -1.28e-3   ,   -1.28e-3,&	  
        -1.28e-3   ,   -1.28e-3   ,   -1.28e-3   ,   -1.28e-3	,   -8.04e-3   ,   -8.04e-3,&	  
        -8.04e-3   ,   -8.04e-3   ,   -8.04e-3   ,   -8.04e-3	,   -8.04e-3   ,   -8.04e-3,&	  
        -8.04e-3   ,   -8.04e-3   ,   -8.04e-3   ,   -8.04e-3	,   -8.04e-3   ,   -8.04e-3,&	  
        -8.04e-3   ,   -8.04e-3   ,   -8.04e-3   ,   -8.04e-3	,   -8.04e-3   ,   -8.04e-3,&	  
        -8.04e-3   ,   -8.04e-3   ,   -8.04e-3   ,   -8.04e-3	,   -8.04e-3   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,  -0.018,&	  
       -0.018   ,  -0.018   ,  -0.018   ,  -0.018	,  -0.018   ,   0.003,&	  
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003,&	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003,&	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.014,&	   
        0.014   ,   0.014   ,   0.014   ,   0.014	,   0.014   ,   0.014,&	   
        0.014   ,   0.014   ,   0.014   ,   0.014	,   0.014   ,   0.014,&	   
        0.014   ,   0.014   ,   0.014   ,   0.014	,   0.014   ,   0.014,&	   
        0.014   ,   0.014   ,   0.014   ,   0.014 /)



ga=  (/   0.841   ,   0.841   ,   0.841   ,   0.841	,   0.841   ,   0.841, &   
        0.841   ,   0.841   ,   0.841   ,   0.841	,   0.841   ,   0.841, &
        0.841   ,   0.841   ,   0.841   ,   0.841	,   0.821   ,   0.821, &
        0.821   ,   0.821   ,   0.821   ,   0.821	,   0.821   ,   0.821, &
        0.821   ,   0.821   ,   0.821   ,   0.821	,   0.821   ,   0.821, &
        0.821   ,   0.821   ,   0.821   ,   0.821	,   0.821   ,   0.821, &	    
        0.786   ,   0.786   ,   0.786   ,   0.786	,   0.786   ,   0.786, &	
        0.786   ,   0.786   ,   0.786   ,   0.786	,   0.786   ,   0.786, &	 
        0.786   ,   0.786   ,   0.786   ,   0.786	,   0.820   ,   0.820, &	 
        0.820   ,   0.820   ,   0.820   ,   0.820	,   0.820   ,   0.820, &
        0.820   ,   0.820   ,   0.820   ,   0.820	,   0.820   ,   0.820, &	      
        0.820   ,   0.820   ,   0.820   ,   0.820	,   0.820   ,   0.820, &	
        0.820   ,   0.820   ,   0.820   ,   0.820	,   0.820   ,   0.840, &	 
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.840, &
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.840, &
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.840, &
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.840, &
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.840, &	 
        0.840   ,   0.840   ,   0.840   ,   0.840	,   0.840   ,   0.250, &    
        0.250   ,   0.250	  ,   0.250   ,   0.250   ,   0.250   ,   0.250, &
        0.250   ,   0.250	  ,   0.250   ,   0.250   ,   0.250   ,   0.250, &	       
        0.250   ,   0.250	  ,   0.250   ,   0.250   ,   0.250   ,   0.500, &
        0.500   ,   0.500	  ,   0.500   ,   0.500   ,   0.500   ,   0.500, &
        0.500   ,   0.500	  ,   0.500   ,   0.500   ,   0.500   ,   0.500, &
        0.500   ,   0.500	  ,   0.500   ,   0.500   ,   0.500   ,   0.500, &	 
        0.500   ,   0.500	  ,   0.500   ,   0.500 /)


gb=  (/   0.002080   ,   0.002080   ,   0.002080   ,   0.002080	,   0.002080   ,   0.002080, &
        0.002080   ,   0.002080   ,   0.002080   ,   0.002080	,   0.002080   ,   0.002080, &	   
        0.002080   ,   0.002080   ,   0.002080   ,   0.002080	,   0.003060   ,   0.003060, &	   
        0.003060   ,   0.003060   ,   0.003060   ,   0.003060	,   0.003060   ,   0.003060, &	   
        0.003060   ,   0.003060   ,   0.003060   ,   0.003060	,   0.003060   ,   0.003060, &	   
        0.003060   ,   0.003060   ,   0.003060   ,   0.003060	,   0.003060   ,   0.003060, &	   
        0.005320   ,   0.005320   ,   0.005320   ,   0.005320	,   0.005320   ,   0.005320, &	   
        0.005320   ,   0.005320   ,   0.005320   ,   0.005320	,   0.005320   ,   0.005320, &	   
        0.005320   ,   0.005320   ,   0.005320   ,   0.005320	,   0.005590   ,   0.005590, &	   
        0.005590   ,   0.005590   ,   0.005590   ,   0.005590	,   0.005590   ,   0.005590, &	   
        0.005590   ,   0.005590   ,   0.005590   ,   0.005590	,   0.005590   ,   0.005590, &	   
        0.005590   ,   0.005590   ,   0.005590   ,   0.005590	,   0.005590   ,   0.005590, &	   
        0.005590   ,   0.005590   ,   0.005590   ,   0.005590	,   0.005590   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,   0.003, &	   
        0.003   ,   0.003   ,   0.003   ,   0.003	,   0.003   ,  -0.080, &	   
       -0.080   ,  -0.080   ,  -0.080   ,  -0.080	,  -0.080   ,  -0.080, &
       -0.080   ,  -0.080   ,  -0.080   ,  -0.080	,  -0.080   ,  -0.080, &
       -0.080   ,  -0.080   ,  -0.080   ,  -0.080	,  -0.080   ,  -0.070, &
       -0.070   ,  -0.070   ,  -0.070   ,  -0.070	,  -0.070   ,  -0.070, &
       -0.070   ,  -0.070   ,  -0.070   ,  -0.070	,  -0.070   ,  -0.070, &
       -0.070   ,  -0.070   ,  -0.070   ,  -0.070	,  -0.070   ,  -0.070, &
       -0.070   ,  -0.070   ,  -0.070   ,  -0.070 /)


tia= (/  30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  30.6, &	
        30.6  ,  30.6	,  30.6   ,  30.6   ,  30.6   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1   ,  63.1   ,  63.1, &	
        63.1  ,  63.1	,  63.1   ,  63.1 /)

tib= (/  254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  254.8, &
        254.8	,  254.8   ,  254.8   ,  254.8   ,  254.8   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0   ,  265.0   ,  265.0, &
        265.0	,  265.0   ,  265.0   ,  265.0 /)



wia= (/  0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.001676   ,   0.004115   ,   0.004115	,   0.004115   ,   0.004115, &
        0.154500   ,   0.154500   ,   0.154500   ,   0.154500	,   0.278800   ,   0.278800, &
        0.278800   ,   0.248300   ,   0.248300   ,   0.248300	,   0.248300   ,   0.248300, &
        0.248300   ,   0.248300   ,   0.248300   ,   0.196500	,   0.497   ,   0.497, &
        0.497   ,   0.497   ,   0.497   ,   0.497	,   0.497   ,   0.497, &
        0.497   ,   0.497   ,   0.497   ,   0.497	,   0.497   ,   0.497, &
        0.497   ,   0.497   ,   0.497   ,   0.497	,   0.497   ,   0.497, &
        0.462400   ,   0.462400   ,   0.462400   ,   0.462400	,   0.495400   ,   0., &
        0.   ,   0.   ,   0.   ,   0.   ,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0.	,   0.   ,   0., &
        0.   ,   0.   ,   0.   ,   0. /)



wib= (/  0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.093820   ,  0.226700   ,  0.226700   ,  0.226700   ,  0.226700, &
        0.221100   ,  0.221100   ,  0.221100   ,  0.221100   ,  0.194500   ,  0.194500, &
        0.194500   ,  0.200900   ,  0.200900   ,  0.200900   ,  0.200900   ,  0.200900, &
        0.200900   ,  0.200900   ,  0.200900   ,  0.213   ,  0.013410   ,  0.013410, &
        0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410, &
        0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410, &
        0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410   ,  0.013410, &
        0.740   ,  0.740   ,  0.740   ,  0.740   ,  0.032410   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0. /)


gia= (/  0.837100   ,  0.837100   ,  0.837100   ,  0.837100   ,  0.837100   ,  0.845300, &
        0.852100   ,  0.852100   ,  0.852600   ,  0.853900   ,  0.853900   ,  0.854100, &
        0.854900   ,  0.854600   ,  0.854600   ,  0.854600   ,  0.855800   ,  0.855800, &
        0.855800   ,  0.855800   ,  0.855400   ,  0.855400   ,  0.855400   ,  0.857100, &
        0.857100   ,  0.857100   ,  0.857100   ,  0.858800   ,  0.858800   ,  0.858800, &
        0.858800   ,  0.861100   ,  0.863100   ,  0.863100   ,  0.863100   ,  0.863100, &
        0.901800   ,  0.901800   ,  0.901800   ,  0.901800   ,  0.930500   ,  0.930500, &
        0.930500   ,  0.924900   ,  0.924900   ,  0.924900   ,  0.924900   ,  0.924900, &
        0.924900   ,  0.924900   ,  0.924900   ,  0.923200   ,  0.993800   ,  0.993800, &
        0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800, &
        0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800, &
        0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800   ,  0.993800, &
        0.959400   ,  0.959400   ,  0.959400   ,  0.959400   ,  0.980400   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., & 
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., & 
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0. /)

gib= (/  0.016830   ,  0.016830   ,  0.016830   ,  0.016730   ,  0.016730   ,  0.016510, &
        0.016290   ,  0.016290   ,  0.016040   ,  0.016160   ,  0.016160   ,  0.016090, &
        0.016140   ,  0.016   ,  0.016   ,  0.016   ,  0.015940   ,  0.015940, &
        0.015940   ,  0.015940   ,  0.015940   ,  0.015940   ,  0.015940   ,  0.015920, &
        0.015920   ,  0.015920   ,  0.015920   ,  0.016010   ,  0.016010   ,  0.016010, &
        0.016010   ,  0.016110   ,  0.016070   ,  0.016070   ,  0.016070   ,  0.016070, &
        0.019120   ,  0.019120   ,  0.019120   ,  0.019120   ,  0.020560   ,  0.020560, &
        0.020560   ,  0.019760   ,  0.019760   ,  0.019760   ,  0.019760   ,  0.019760, &
        0.019760   ,  0.019760   ,  0.019760   ,  0.016970   ,  0.002930   ,  0.002930, &
        0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930, &
        0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930, &
        0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930   ,  0.002930, &
        0.002750   ,  0.002750   ,  0.002750   ,  0.002750   ,  0.010300   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0. /)

alpha= (/0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0.081e-3, &
        0.081e-3   ,  0.081e-3   ,  0.081e-3   ,  0.268   ,  0.268   ,  0.268, &
        0.268   ,  0.652   ,  0.715   ,  0.715   ,  0.715   ,  0.715, &      
        0.033500   ,  0.033500   ,  0.033500   ,  0.033500   ,  0.071900   ,  0.071900, &
        0.071900   ,  0.061200   ,  0.061200   ,  0.061200   ,  0.061200   ,  0.061200, &
        0.061200   ,  0.061200   ,  0.061200   ,  0.044900   ,  0.207   ,  0.207, &
        0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207, &
        0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207, &
        0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207   ,  0.207, &
        0.001840   ,  0.001840   ,  0.001840   ,  0.001840   ,  0.273   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0. /)


gama= (/ 0.032710   ,  0.032710   ,  0.032710   ,  0.032530   ,  0.032530   ,  0.032300, &
        0.032920   ,  0.032920   ,  0.032470   ,  0.032600   ,  0.032600   ,  0.032550, &
        0.032770   ,  0.033190   ,  0.033190   ,  0.033190   ,  0.033160   ,  0.033160, &   
        0.033160   ,  0.033160   ,  0.033160   ,  0.033160   ,  0.033160   ,  0.033720, &      
        0.033720   ,  0.033720   ,  0.033720   ,  0.034410   ,  0.034410   ,  0.034410, &       
        0.034410   ,  0.035370   ,  0.036530   ,  0.036530   ,  0.036530   ,  0.036530, &     
        0.049990   ,  0.049990   ,  0.049990   ,  0.049990   ,  0.063600   ,  0.063600, &    
        0.063600   ,  0.060450   ,  0.060450   ,  0.060450   ,  0.060450   ,  0.060450, &     
        0.060450   ,  0.060450   ,  0.060450   ,  0.050150   ,  0.044600   ,  0.044600, &
        0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600, &
        0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600, &
        0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600   ,  0.044600, &
        0.029370   ,  0.029370   ,  0.029370   ,  0.029370   ,  0.146200   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &    
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &
        0.   ,  0.   ,  0.   ,  0.   ,  0.   ,  0., &  
        0.   ,  0.   ,  0.   ,  0. /)



caseE(1,:)= (/2.92764  , 2.65020   , 2.46524   , 2.29062   , 2.18251   , 1.92100   , &
            1.50222  , 1.39344   , 1.23868   , 1.17689   , 1.09044   , 0.89400   , &
	    0.77024  , 0.62330   , 0.60230   , 0.56686   , 0.53229   , 0.48463   , &
	    0.42810  , 0.37431   , 0.33707   , 0.29543   , 0.26004   , 0.20781   , &
	    0.18062  , 0.16959   , 0.15578   , 0.15196   , 0.14466   , 0.13800   , &
	    0.13800  , 0.13800   , 0.13800   , 0.13800   , 0.13800   , 0.13800   , &
	    0.13800  , 0.13800   , 0.13800   , 0.13800   , 0.13800   , 0.13800   , &
	    0.13800  , 0.13800   , 0.13800   , 0.13800   , 0.13800   , 0.13800   , &
	    0.13800  , 0.13800   /)


caseE(2,:)= (/3.01122  , 2.79210   , 2.64602   , 2.50038   , 2.40849   , 2.14322   , &
            1.71917  , 1.61234   , 1.43824   , 1.36841   , 1.27017   , 1.05050   , &
	    0.90505  , 0.72981   , 0.70419   , 0.66048   , 0.61668   , 0.55594   , &
	    0.48389  , 0.41535   , 0.36626   , 0.31074   , 0.26379   , 0.19434   , &
	    0.15743  , 0.14089   , 0.12277   , 0.11736   , 0.10665   , 0.09850   , &
	    0.09850  , 0.09850   , 0.09850   , 0.09850   , 0.09850   , 0.09850   , &
	    0.09850  , 0.09850   , 0.09850   , 0.09850   , 0.09850   , 0.09850   , &
	    0.09850  , 0.09850   , 0.09850   , 0.09850   , 0.09850   , 0.09850   , &
	    0.09850  , 0.09850   /)


caseE(3,:)= (/3.12422  , 2.91710   , 2.77902   , 2.64924   , 2.56903   , 2.30011   , &
            1.87089  , 1.76528   , 1.57674   , 1.50091   , 1.39389   , 1.15650   , &
	    0.99544  , 0.79970   , 0.77070   , 0.72071   , 0.67064   , 0.60122   , &
	    0.51888  , 0.44077   , 0.38517   , 0.32058   , 0.26624   , 0.18664   , &
	    0.14504  , 0.12534   , 0.10546   , 0.09910   , 0.08732   , 0.07850   , &
	    0.07850  , 0.07850   , 0.07850   , 0.07850   , 0.07850   , 0.07850   , &
	    0.07850  , 0.07850   , 0.07850   , 0.07850   , 0.07850   , 0.07850   , &
	    0.07850  , 0.07850   , 0.07850   , 0.07850   , 0.07850   , 0.07850   , &
	    0.07850  , 0.07850   /)


caseE(4,:)= (/3.02062  , 2.83510   , 2.71142   , 2.59346   , 2.52016   , 2.26722   , &
            1.86396  , 1.76543   , 1.58033   , 1.50578   , 1.40139   , 1.17300   , &
	    1.01396  , 0.81903   , 0.78978   , 0.73971   , 0.68911   , 0.61878   , &
	    0.53537  , 0.45612   , 0.39859   , 0.33241   , 0.27560   , 0.19343   , &
	    0.15044  , 0.12995   , 0.10946   , 0.10310   , 0.09182   , 0.08300   , &
	    0.08300  , 0.08300   , 0.08300   , 0.08300   , 0.08300   , 0.08300   , &
	    0.08300  , 0.08300   , 0.08300   , 0.08300   , 0.08300   , 0.08300   , &
	    0.08300  , 0.08300   , 0.08300   , 0.08300   , 0.08300   , 0.08300   , &
	    0.08300  , 0.08300   /)


caseE(5,:)= (/2.94676  , 2.76580  , 2.64516  , 2.52924   , 2.45703   , 2.21156   , &
            1.82015  , 1.72429  , 1.54303  , 1.47001   , 1.36772   , 1.14450   , &
	    0.98778  , 0.79554  , 0.76666  , 0.71712   , 0.66684   , 0.59690   , &
	    0.51395  , 0.43504  , 0.37656  , 0.30957   , 0.25239   , 0.16936   , &
	    0.12589  , 0.10501  , 0.08546  , 0.07910   , 0.06765   , 0.06   , &
	    0.06  , 0.06  , 0.06  , 0.06   , 0.06   , 0.06   , &
	    0.06  , 0.06  , 0.06  , 0.06   , 0.06   , 0.06   , &
	    0.06  , 0.06  , 0.06  , 0.06   , 0.06   , 0.06   , &
	    0.06  , 0.06  /)


caseE(6,:)= (/2.71208  , 2.54840  , 2.43928  , 2.33189  , 2.26443  , 2.04578   , 1.69812   , &
            1.61324  , 1.44734  , 1.38045  , 1.28700  , 1.08700  , 0.94300   , 0.76443   , &
	    0.73718  , 0.69014  , 0.64260  , 0.57654  , 0.49820  , 0.42369   , 0.36803   , &
	    0.30397  , 0.24881  , 0.16743  , 0.12434  , 0.10307  , 0.08296   , 0.07660   , &
	    0.06432  , 0.05600  , 0.05600  , 0.05600  , 0.05600  , 0.05600   , 0.05600   , &
	    0.05600  , 0.05600  , 0.05600  , 0.05600  , 0.05600  , 0.05600   , 0.05600   , &
	    0.05600  , 0.05600  , 0.05600  , 0.05600  , 0.05600  , 0.05600   , &
	    0.05600  , 0.05600  /)

caseE(7,:)= (/2.87372  , 2.70860  , 2.59852  , 2.49397  , 2.42911  , 2.19967  , 1.83324  , &
            1.74349  , 1.56870  , 1.49823  , 1.39856  , 1.18500  , 1.03059  , 0.83903  , &
	    0.80978  , 0.76133  , 0.71089  , 0.64017  , 0.55630  , 0.47654  , 0.41645  , &
	    0.34705  , 0.28548  , 0.19431  , 0.14385  , 0.11864  , 0.09435  , 0.08608  , &
	    0.07231  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , &
	    0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  ,&
	    0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , 0.06200  , &
	    0.06200  , 0.06200  /)
	    

caseE(8,:)= (/2.87372  , 2.70860   , 2.59852   , 2.49397   , 2.42911   , 2.19967   , &
            1.83324  , 1.74349   , 1.56870   , 1.49823   , 1.39856   , 1.18500   , &
	    1.03059  , 0.83903   , 0.80978   , 0.76133   , 0.71089   , 0.64017   , &
	    0.55630  , 0.47654   , 0.41645   , 0.34705   , 0.28548   , 0.19431   , &
	    0.14385  , 0.11864   , 0.09435   , 0.08608   , 0.07231   , 0.06200   , &
	    0.06200  , 0.06200   , 0.06200   , 0.06200   , 0.06200   , 0.06200   , &
	    0.06200  , 0.06200   , 0.06200   , 0.06200   , 0.06200   , 0.06200   , &
	    0.06200  , 0.06200   , 0.06200   , 0.06200   , 0.06200   , 0.06200   , &
	    0.06200  , 0.06200   /)

caseE(9,:)= (/2.53656  , 2.39880   , 2.30696   , 2.21468   , 2.15630   , 1.97033   , &
            1.67334  , 1.59968   , 1.44606   , 1.38402   , 1.29744   , 1.11800   , &
	    0.97863  , 0.80410   , 0.77710   , 0.73176   , 0.68460   , 0.61854   , &
	    0.54020  , 0.46554   , 0.40616   , 0.33784   , 0.27648   , 0.18517   , &
	    0.13385  , 0.10864   , 0.08435   , 0.07608   , 0.06265   , 0.05300   , &
	    0.05300  , 0.05300   , 0.05300   , 0.05300   , 0.05300   , 0.05300   , &
	    0.05300  , 0.05300   , 0.05300   , 0.05300   , 0.05300   , 0.05300   , &
	    0.05300  , 0.05300   , 0.05300   , 0.05300   , 0.05300   , 0.05300   , &
	    0.05300  , 0.05300   /)

caseW(1,:)= (/0.92976  , 0.92880   , 0.92816   , 0.92697   , 0.92611   , 0.92200   , &
            0.91456  , 0.91212   , 0.90645   , 0.90415   , 0.90078   , 0.89100   , &
	    0.88175  , 0.86960   , 0.86760   , 0.86295   , 0.85763   , 0.85012   , &
	    0.84121  , 0.83254   , 0.82355   , 0.81395   , 0.80581   , 0.79358   , &
	    0.79189  , 0.79898   , 0.80504   , 0.81140   , 0.82235   , 0.83600   , &
	    0.83600  , 0.83600   , 0.83600   , 0.83600   , 0.83600   , 0.83600   , &
	    0.83600  , 0.83600   , 0.83600   , 0.83600   , 0.83600   , 0.83600   , &
	    0.83600  , 0.83600   , 0.83600   , 0.83600   , 0.83600   , 0.83600   , &
	    0.83600  , 0.83600   /)

caseW(2,:)= (/0.93168  , 0.93240   , 0.93288   , 0.93300   , 0.93300   , 0.93078   , &
            0.92654  , 0.92507   , 0.92068   , 0.91889   , 0.91644   , 0.91050   , &
	    0.90356  , 0.89445   , 0.89295   , 0.88967   , 0.88508   , 0.87835   , &
	    0.87036  , 0.86277   , 0.85416   , 0.84322   , 0.83201   , 0.81189   , &
	    0.80190  , 0.80111   , 0.80122   , 0.80504   , 0.81118   , 0.82150   , &
	    0.82150  , 0.82150   , 0.82150   , 0.82150   , 0.82150   , 0.82150   , &
	    0.82150  , 0.82150   , 0.82150   , 0.82150   , 0.82150   , 0.82150   , &
	    0.82150  , 0.82150   , 0.82150   , 0.82150   , 0.82150   , 0.82150   , &
	    0.82150  , 0.82150   /)

caseW(3,:)= (/0.93198  , 0.93390   , 0.93518   , 0.93601   , 0.93645   , 0.93517   , &
            0.93228  , 0.93106   , 0.92730   , 0.92577   , 0.92411   , 0.91900   , &
	    0.91322  , 0.90529   , 0.90391   , 0.90107   , 0.89696   , 0.89087   , &
	    0.88365  , 0.87669   , 0.86748   , 0.85627   , 0.84366   , 0.81948   , &
	    0.80336  , 0.79824   , 0.79261   , 0.79452   , 0.79617   , 0.80400   , &
	    0.80400  , 0.80400   , 0.80400   , 0.80400   , 0.80400   , 0.80400   , &
	    0.80400  , 0.80400   , 0.80400   , 0.80400   , 0.80400   , 0.80400   , &
	    0.80400  , 0.80400   , 0.80400   , 0.80400   , 0.80400   , 0.80400   , &
	    0.80400  , 0.80400  /)

caseW(4,:)= (/0.92998  , 0.93190   , 0.93318   , 0.93427   , 0.93492   , 0.93389   , &
            0.93152  , 0.93055   , 0.92711   , 0.92570   , 0.92389   , 0.91950   , &
	    0.91372  , 0.90579   , 0.90441   , 0.90157   , 0.89746   , 0.89137   , &
	    0.88415  , 0.87735   , 0.86898   , 0.85777   , 0.84505   , 0.82041   , &
	    0.80381  , 0.79830   , 0.79271   , 0.79494   , 0.79818   , 0.80650   , &
	    0.80650  , 0.80650   , 0.80650   , 0.80650   , 0.80650   , 0.80650   , &
	    0.80650  , 0.80650   , 0.80650   , 0.80650   , 0.80650   , 0.80650   , &
	    0.80650  , 0.80650   , 0.80650   , 0.80650   , 0.80650   , 0.80650   , &
	    0.80650  , 0.80650  /)

caseW(5,:)= (/0.93104  , 0.93320   , 0.93464   , 0.93603   , 0.93689   , 0.93633   ,& 
            0.93452  , 0.93355   , 0.93041   , 0.92914   , 0.92739   , 0.92400   , & 
	    0.91851  , 0.91113   , 0.90988   , 0.90748   , 0.90369   , 0.89799   , & 
	    0.89123  , 0.88477   , 0.87598   , 0.86477   , 0.85070   , 0.82200   , & 
	    0.79912  , 0.78809   , 0.77669   , 0.77574   , 0.77484   , 0.78050   , & 
	    0.78050  , 0.78050   , 0.78050   , 0.78050   , 0.78050   , 0.78050   , &
	    0.78050  , 0.78050   , 0.78050   , 0.78050   , 0.78050   , 0.78050   , &
	    0.78050  , 0.78050   , 0.78050   , 0.78050   , 0.78050   , 0.78050   , &
	    0.78050  , 0.78050   /)

caseW(6,:)= (/0.92860  , 0.93100   , 0.93260   , 0.93403   , 0.93489   , 0.93456   , &
            0.93351  , 0.93302   , 0.92991   , 0.92864   , 0.92711   , 0.92400   , &
	    0.91880  , 0.91163   , 0.91038   , 0.90838   , 0.90499   , 0.89981   , &
	    0.89366  , 0.88769   , 0.87920   , 0.86905   , 0.85584   , 0.82978   , &
	    0.80852  , 0.79670   , 0.78359   , 0.78232   , 0.77800   , 0.78100   , &
	    0.78100  , 0.78100   , 0.78100   , 0.78100   , 0.78100   , 0.78100   , &
	    0.78100  , 0.78100   , 0.78100   , 0.78100   , 0.78100   , 0.78100   , &
	    0.78100  , 0.78100   , 0.78100   , 0.78100   , 0.78100   , 0.78100   , &
	    0.78100  , 0.78100   /)

caseW(7,:)= (/0.92860  , 0.93100   , 0.93260   , 0.93403   , 0.93489   , 0.93456   , &
            0.93302  , 0.93205   , 0.92953   , 0.92851   , 0.92711   , 0.92400   , &
	    0.91880  , 0.91230   , 0.91130   , 0.90938   , 0.90614   , 0.90122   , &
	    0.89538  , 0.88969   , 0.88191   , 0.87284   , 0.86126   , 0.83664   , &
	    0.81452  , 0.80270   , 0.78678   , 0.78296   , 0.77566   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   /)


caseW(8,:)= (/0.92860  , 0.93100   , 0.93260   , 0.93403   , 0.93489   , 0.93456   , &
            0.93302  , 0.93205   , 0.92953   , 0.92851   , 0.92711   , 0.92400   , &
	    0.91880  , 0.91230   , 0.91130   , 0.90938   , 0.90614   , 0.90122   , &
	    0.89538  , 0.88969   , 0.88191   , 0.87284   , 0.86126   , 0.83664   , &
	    0.81452  , 0.80270   , 0.78678   , 0.78296   , 0.77566   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   , 0.77500   , 0.77500   , 0.77500   , 0.77500   , &
	    0.77500  , 0.77500   /)


caseW(9,:)= (/0.92372  , 0.92660   , 0.92852   , 0.93054   , 0.93184   , 0.93200   , &
            0.93200  , 0.93200   , 0.92891   , 0.92764   , 0.92700   , 0.92500   , &
	    0.92037  , 0.91498   , 0.91423   , 0.91238   , 0.90929   , 0.90463   , &
	    0.89910  , 0.89385   , 0.88691   , 0.87784   , 0.86605   , 0.84036   , &
	    0.81603  , 0.80027   , 0.77996   , 0.77360   , 0.76332   , 0.76   , &
	    0.76000  , 0.76000   , 0.76000   , 0.76000   , 0.76000   , 0.76000   , &
	    0.76000  , 0.76000   , 0.76000   , 0.76000   , 0.76000   , 0.76000   , &
	    0.76000  , 0.76000   , 0.76000   , 0.76000   , 0.76000   , 0.76000   , &
	    0.76000  , 0.76000   /)

caseG(1,:)= (/0.73140   , 0.71700   , 0.70740   , 0.70038   , 0.69649   , 0.67867   , &
            0.64724   , 0.63749   , 0.62219   , 0.61606   , 0.60633   , 0.58000   , &
	    0.55918   , 0.53388   , 0.53013   , 0.52333   , 0.51959   , 0.51545   , &
	    0.51053   , 0.50615   , 0.51667   , 0.53108   , 0.55748   , 0.60573   , &
	    0.64484   , 0.67557   , 0.68945   , 0.69708   , 0.69768   , 0.70200   , &
	    0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , &
	    0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , &
	    0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , 0.70200   , &
	    0.70200   , 0.70200   /)


caseG(2,:)= (/0.73418   , 0.72290   , 0.71538   , 0.71119   , 0.70924   , 0.69233   , &
            0.66443   , 0.65735   , 0.64312   , 0.63737   , 0.62783   , 0.60200   , &
	    0.58031   , 0.55235   , 0.54785   , 0.54002   , 0.53135   , 0.51904   , &
	    0.50445   , 0.49077   , 0.48878   , 0.48772   , 0.49933   , 0.53258   , &
	    0.57512   , 0.61609   , 0.64310   , 0.65900   , 0.67269   , 0.68700   , &
	    0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , &
	    0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , &
	    0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , 0.68700   , &
	    0.68700   , 0.68700   /)

caseG(3,:)= (/0.73616   , 0.72680   , 0.72056   , 0.71874   , 0.71853   , 0.70183   , &
            0.67515   , 0.66929   , 0.65543   , 0.64981   , 0.64033   , 0.61450   , &
	    0.59223   , 0.56250   , 0.55750   , 0.54831   , 0.53664   , 0.51967   , &
	    0.49955   , 0.48046   , 0.47034   , 0.45966   , 0.46196   , 0.48451   , &
	    0.52726   , 0.57335   , 0.60894   , 0.63056   , 0.65304   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   /)


caseG(4,:)= (/0.73258   , 0.72490   , 0.71978   , 0.71876   , 0.71897   , 0.70367   , &
            0.67987   , 0.67523   , 0.66143   , 0.65581   , 0.64633   , 0.62250   , &
	    0.60226   , 0.57501   , 0.57039   , 0.56171   , 0.55036   , 0.53378   , &
	    0.51412   , 0.49546   , 0.48373   , 0.47065   , 0.46976   , 0.48552   , &
	    0.52521   , 0.57091   , 0.60694   , 0.62856   , 0.65254   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , 0.67350   , &
	    0.67350   , 0.67350   /)

caseG(5,:)= (/0.72920   , 0.72200   , 0.71720   , 0.71626   , 0.71647   , 0.70139   , &
            0.67811   , 0.67372   , 0.65993   , 0.65431   , 0.64506   , 0.62150   , &
	    0.60126   , 0.57368   , 0.56893   , 0.55940   , 0.54711   , 0.52923   , &
	    0.50804   , 0.48773   , 0.47132   , 0.45318   , 0.44415   , 0.44513   , &
	    0.47611   , 0.52102   , 0.56297   , 0.58936   , 0.62389   , 0.65400   , &
	    0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , &
	    0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , & 
	    0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , 0.65400   , &
	    0.65400   , 0.65400   /)

caseG(6,:)= (/0.71880   , 0.71400   , 0.71080   , 0.71103   , 0.71189   , 0.69822   , &
            0.67807   , 0.67515   , 0.66143   , 0.65581   , 0.64678   , 0.62600   , &
	    0.60865   , 0.58453   , 0.58028   , 0.57171   , 0.56021   , 0.54337   , &
	    0.52340   , 0.50438   , 0.48847   , 0.46978   , 0.45909   , 0.45522   , &
	    0.48002   , 0.52020   , 0.55596   , 0.58076   , 0.61472   , 0.64400   , &
	    0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , &
	    0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , &
	    0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , 0.64400   , &
	    0.64400   , 0.64400   /)


caseG(7,:)= (/0.72644   , 0.72020   , 0.71604   , 0.71603   , 0.71689   , 0.70322   , &
            0.68259   , 0.67917   , 0.66543   , 0.65981   , 0.65122   , 0.63100   , &
	    0.61307   , 0.58785   , 0.58335   , 0.57552   , 0.56527   , 0.55024   , &
	    0.53242   , 0.51538   , 0.50233   , 0.48792   , 0.47994   , 0.47838   , &
	    0.49733   , 0.53200   , 0.55973   , 0.58072   , 0.60938   , 0.63500   , &
	    0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
	    0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
	    0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
	    0.63500   , 0.63500   /)

caseG(8,:)= (/0.72644   , 0.72020   , 0.71604   , 0.71603   , 0.71689   , 0.70322   , &
            0.68259   , 0.67917   , 0.66543   , 0.65981   , 0.65122   , 0.63100   , &
            0.61307   , 0.58785   , 0.58335   , 0.57552   , 0.56527   , 0.55024   , &
            0.53242   , 0.51538   , 0.50233   , 0.48792   , 0.47994   , 0.47838   , &
            0.49733   , 0.53200   , 0.55973   , 0.58072   , 0.60938   , 0.63500   ,&
            0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
            0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
            0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , 0.63500   , &
            0.63500   , 0.63500   /)


caseG(9,:)= (/0.70840   , 0.70600   , 0.70440   , 0.70554   , 0.70684   , 0.69678   , &
            0.68254   , 0.68107   , 0.66866   , 0.66355   , 0.65567   , 0.64000   , &
            0.62612   , 0.60520   , 0.60120   , 0.59433   , 0.58532   , 0.57211   , &
            0.55644   , 0.54138   , 0.52547   , 0.50678   , 0.49069   , 0.47100   , &
            0.47455   , 0.50291   , 0.52973   , 0.55072   , 0.58706   , 0.61900   , &
            0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , &
            0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , &
            0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , 0.61900   , &
            0.61900   , 0.61900   /)


     rad_data_not_read=.false.

     !   DERIVED PARAMETERS
     !
     jdble   =   2*nlayer
     jn      =   jdble-1
     

   end subroutine master_read_carma_data
  
end module mem_globrad 
