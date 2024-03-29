Module consts_coms

! Making the constants to match when running a coupled run.

#if defined(COUPLED)
   use rconstants, only:                                                                   &
       b_pi1        => pi1        , b_twopi      => twopi      , b_pio180     => pio180    &
     , b_pi4        => pi4        , b_pio4       => pio4       , b_srtwo      => srtwo     &
     , b_srthree    => srthree    , b_srtwoi     => srtwoi     , b_srthreei   => srthreei  &
     , b_onethird   => onethird   , b_stefan     => stefan     , b_boltzmann  => boltzmann &
     , b_t00        => t00        , b_yr_day     => yr_day     , b_day_sec    => day_sec   &
     , b_day_hr     => day_hr     , b_hr_sec     => hr_sec     , b_min_sec    => min_sec   &
     , b_vonk       => vonk       , b_grav       => grav       , b_erad       => erad      &
     , b_p00        => p00        , b_p00i       => p00i       , b_rdry       => rdry      &
     , b_cp         => cp         , b_cpog       => cpog       , b_rocp       => rocp      &
     , b_cpor       => cpor       , b_cpi        => cpi        , b_rh2o       => rh2o      &
     , b_ep         => ep         , b_epi        => epi        , b_toodry     => toodry    &
     , b_cliq       => cliq       , b_cliqvlme   => cliqvlme   , b_cliqi      => cliqi     &
     , b_cice       => cice       , b_cicevlme   => cicevlme   , b_cicei      => cicei     &
     , b_t3ple      => t3ple      , b_t3plei     => t3plei     , b_es3ple     => es3ple    &
     , b_es3plei    => es3plei    , b_epes3ple   => epes3ple   , b_alvl       => alvl      &
     , b_alvi       => alvi       , b_alli       => alli       , b_allivlme   => allivlme  &
     , b_allii      => allii      , b_wdns       => wdns       , b_erad2      => erad2     &
     , b_sqrtpii    => sqrtpii    , b_onesixth   => onesixth   , b_qicet3     => qicet3    &
     , b_wdnsi      => wdnsi      , b_gorh2o     => gorh2o     , b_idns       => idns      &
     , b_idnsi      => idnsi      , b_tsupercool => tsupercool , b_twothirds  => twothirds &
     , b_qliqt3     => qliqt3     , b_sqrt2o2    => sqrt2o2    , b_mmdry      => mmdry     &
     , b_mmh2o      => mmh2o      , b_mmco2      => mmco2      , b_mmdoc      => mmdoc     &
     , b_mmcod      => mmcod      , b_mmdry1000  => mmdry1000  , b_mmdryi     => mmdryi    &
     , b_rmol       => rmol       , b_volmol     => volmol     , b_volmoll    => volmoll   &
     , b_mmcod1em6  => mmcod1em6  , b_mmco2i     => mmco2i     , b_epim1      => epim1     &
     , b_ttripoli   => ttripoli   , b_htripoli   => htripoli   , b_htripolii  => htripolii &
     , b_cpi4       => cpi4       , b_aklv       => aklv       , b_akiv       => akiv      &
     , b_rdryi      => rdryi      , b_eta3ple    => eta3ple    , b_cimcp      => cimcp     &
     , b_clmcp      => clmcp      , b_p00k       => p00k       , b_p00ki      => p00ki     &
     , b_halfpi     => halfpi     , b_yr_sec     => yr_sec     , b_sqrttwopi  => sqrttwopi &
     , b_sqrthalfpi => sqrthalfpi 

   implicit none

   real, parameter :: pi1        = b_pi1        , twopi      = b_twopi
   real, parameter :: pio180     = b_pio180     , pi4        = b_pi4
   real, parameter :: pio4       = b_pio4       , srtwo      = b_srtwo
   real, parameter :: srthree    = b_srthree    , srtwoi     = b_srtwoi
   real, parameter :: srthreei   = b_srthreei   , onethird   = b_onethird
   real, parameter :: twothirds  = b_twothirds  , stefan     = b_stefan
   real, parameter :: boltzmann  = b_boltzmann  , tsupercool = b_tsupercool
   real, parameter :: t00        = b_t00        , yr_day     = b_yr_day
   real, parameter :: day_sec    = b_day_sec    , day_hr     = b_day_hr
   real, parameter :: hr_sec     = b_hr_sec     , min_sec    = b_min_sec
   real, parameter :: vonk       = b_vonk       , grav       = b_grav
   real, parameter :: erad       = b_erad       , p00        = b_p00
   real, parameter :: p00i       = b_p00i       , rdry       = b_rdry
   real, parameter :: cp         = b_cp         , cpog       = b_cpog
   real, parameter :: rocp       = b_rocp       , cpor       = b_cpor
   real, parameter :: cpi        = b_cpi        , rh2o       = b_rh2o
   real, parameter :: ep         = b_ep         , epi        = b_epi
   real, parameter :: toodry     = b_toodry     , cliq       = b_cliq
   real, parameter :: cliqvlme   = b_cliqvlme   , cliqi      = b_cliqi
   real, parameter :: cice       = b_cice       , cicevlme   = b_cicevlme
   real, parameter :: cicei      = b_cicei      , t3ple      = b_t3ple
   real, parameter :: t3plei     = b_t3plei     , es3ple     = b_es3ple
   real, parameter :: es3plei    = b_es3plei    , epes3ple   = b_epes3ple
   real, parameter :: alvl       = b_alvl       , alvi       = b_alvi
   real, parameter :: alli       = b_alli       , allivlme   = b_allivlme
   real, parameter :: allii      = b_allii      , wdns       = b_wdns
   real, parameter :: erad2      = b_erad2      , sqrtpii    = b_sqrtpii
   real, parameter :: onesixth   = b_onesixth   , qicet3     = b_qicet3
   real, parameter :: wdnsi      = b_wdnsi      , gorh2o     = b_gorh2o
   real, parameter :: idns       = b_idns       , idnsi      = b_idnsi
   real, parameter :: qliqt3     = b_qliqt3     , sqrt2o2    = b_sqrt2o2
   real, parameter :: mmdry      = b_mmdry      , mmh2o      = b_mmh2o
   real, parameter :: mmco2      = b_mmco2      , mmdoc      = b_mmdoc
   real, parameter :: mmcod      = b_mmcod      , mmdry1000  = b_mmdry1000 
   real, parameter :: mmdryi     = b_mmdryi     , rmol       = b_rmol
   real, parameter :: volmol     = b_volmol     , volmoll    = b_volmoll
   real, parameter :: mmcod1em6  = b_mmcod1em6  , mmco2i     = b_mmco2i
   real, parameter :: epim1      = b_epim1      , ttripoli   = b_ttripoli
   real, parameter :: htripoli   = b_htripoli   , htripolii  = b_htripolii
   real, parameter :: cpi4       = b_cpi4       , aklv       = b_aklv
   real, parameter :: akiv       = b_akiv       , rdryi      = b_rdryi
   real, parameter :: eta3ple    = b_eta3ple    , cimcp      = b_cimcp
   real, parameter :: clmcp      = b_clmcp      , p00k       = b_p00k
   real, parameter :: p00ki      = b_p00ki      , halfpi     = b_halfpi
   real, parameter :: yr_sec     = b_yr_sec     , sqrthalfpi = b_sqrthalfpi
   real, parameter :: sqrttwopi  = b_sqrttwopi
#else
   implicit none

   !---------------------------------------------------------------------------------------!
   ! Trigonometric constants                                                               !
   !---------------------------------------------------------------------------------------!
   real, parameter :: pi1        = 3.14159265358979  ! Pi                       [      ---]
   real, parameter :: halfpi     = pi1/2             ! Pi/2                     [      ---]
   real, parameter :: twopi      = pi1* 2.           ! 2 Pi                     [      ---]
   real, parameter :: sqrtpii    = 0.564189583547756 ! 1/(pi**0.5)              [      ---]
   real, parameter :: sqrthalfpi = 1.2533141373155   ! (pi/2)**0.5              [      ---]
   real, parameter :: sqrttwopi  = 2. * sqrthalfpi   ! (2*pi)**0.5              [      ---]
   real, parameter :: pio180     = pi1/ 180.         ! Pi/180 (deg -> rad)      [      ---]
   real, parameter :: pi4        = pi1 * 4.          ! 4 Pi                     [      ---]
   real, parameter :: pio4       = pi1 /4.           ! Pi/4                     [      ---]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Algebraic shortcuts                                                                   !
   !---------------------------------------------------------------------------------------!
   real, parameter :: srtwo     = 1.414213562373095 ! Square root of 2.         [      ---]
   real, parameter :: srthree   = 1.732050807568877 ! Square root of 3.         [      ---]
   real, parameter :: sqrt2o2   = 0.5 * srtwo       ! � Square root of 2.       [      ---]
   real, parameter :: srtwoi    = 1./srtwo          ! 1./ Square root of 2.     [      ---]
   real, parameter :: srthreei  = 1./srthree        ! 1./ Square root of 3.     [      ---]
   real, parameter :: onethird  = 1./3.             ! 1/3                       [      ---]
   real, parameter :: twothirds = 2./3.             ! 2/3                       [      ---]
   real, parameter :: onesixth  = 1./6.             ! 1/6                       [      ---]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Universal constants                                                                   !
   !---------------------------------------------------------------------------------------!
   real, parameter :: stefan    = 5.6696e-8         ! Stefan-Boltzmann constant [ W/m�/K^4]
   real, parameter :: boltzmann = 1.3806503e-23     ! Boltzmann constant        [m�kg/s�/K]
   real, parameter :: t00       = 273.15            ! 0�C                       [       �C]
   real, parameter :: rmol      = 8.314510          ! Molar gas constant        [  J/mol/K]
   real, parameter :: volmol    = 0.022710980       ! Molar volume at STP       [       m�]
   real, parameter :: volmoll   = volmol*1e3        ! Molar volume at STP       [        L]
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   ! Molar masses and derived variables                                                    !
   !---------------------------------------------------------------------------------------!
   real, parameter :: mmdry       = 0.02897        ! Mean dry air molar mass    [   kg/mol]
   real, parameter :: mmh2o       = 0.01801505     ! Mean water molar mass      [   kg/mol]
   real, parameter :: mmco2       = 0.0440095      ! Mean CO2 molar mass        [   kg/mol]
   real, parameter :: mmdoc       = mmdry/mmco2    ! mmdry/mmco2                [     ----]
   real, parameter :: mmcod       = mmco2/mmdry    ! mmco2/mmdry                [     ----]
   real, parameter :: mmdry1000   = 1000.*mmdry    ! Mean dry air molar mass    [   kg/mol]
   real, parameter :: mmcod1em6   = mmcod * 1.e-6  ! Convert ppm to kgCO2/kgair [     ----]
   real, parameter :: mmdryi      = 1./mmdry       ! 1./mmdry                   [   mol/kg]
   real, parameter :: mmco2i      = 1./mmco2       ! 1./mmco2                   [   mol/kg]
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   ! Time conversion units                                                                 !
   !---------------------------------------------------------------------------------------!
   real, parameter :: yr_day  = 365.2425         ! # of days in a year          [   day/yr]
   real, parameter :: day_sec = 86400.           ! # of seconds in a day        [    s/day]
   real, parameter :: day_hr  = 24.              ! # of hours in a day          [   hr/day]
   real, parameter :: hr_sec  = 3600.            ! # of seconds in an hour      [     s/hr]
   real, parameter :: min_sec = 60.              ! # of seconds in a minute     [    s/min]
   real, parameter :: yr_sec  = yr_day * day_sec ! # of seconds in a year       [     s/yr]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! General Earth properties                                                              !
   !---------------------------------------------------------------------------------------!
   real, parameter :: vonk      = 0.40        ! Von K�rm�n constant             [      ---]
   real, parameter :: grav      = 9.80665     ! Gravity acceleration            [     m/s�]
   real, parameter :: erad      = 6370997.    ! Earth radius                    [        m]
   real, parameter :: erad2     = 2.*erad     ! Earth diameter                  [        m]
   real, parameter :: p00       = 1.e5        ! Reference pressure              [       Pa]
   real, parameter :: p00i      = 1. / p00    ! 1/p00                           [     1/Pa]
   real, parameter :: p00k      = 26.870941   ! p0 ** (Ra/Cp)                   [ Pa^0.286]
   real, parameter :: p00ki     = 1. / p00k   ! p0 ** (-Ra/Cp)                  [Pa^-0.286]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Dry air properties                                                                    !
   !---------------------------------------------------------------------------------------!
   real, parameter :: rdry   = rmol/mmdry ! Gas constant for dry air (Ra)       [   J/kg/K]
   real, parameter :: rdryi  = mmdry/rmol ! 1./Gas constant for dry air (Ra)    [   kg K/J]
   real, parameter :: cp     = 1004.      ! Specific heat at constant pressure  [   J/kg/K]
   real, parameter :: cpog   = cp /grav   ! cp/g                                [      m/K]
   real, parameter :: rocp   = rdry / cp  ! Ra/cp                               [     ----]
   real, parameter :: cpor   = cp / rdry  ! Cp/Ra                               [     ----]
   real, parameter :: cpi    = 1. / cp    ! 1/Cp                                [   kg K/J]
   real, parameter :: cpi4   = 4. * cpi   ! 4/Cp                                [   kg K/J]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Water vapour properties                                                               !
   !---------------------------------------------------------------------------------------!
   real, parameter :: rh2o   = rmol / mmh2o ! Gas constant for water vapour (Rv)[   J/kg/K]
   real, parameter :: gorh2o = grav / rh2o  ! g/Rv                              [      K/m]
   real, parameter :: ep     = mmh2o/mmdry  ! or Ra/Rv, epsilon, used to find rv[    kg/kg]
   real, parameter :: epi    = mmdry/mmh2o  ! or Rv/Ra, 1/epsilon               [    kg/kg]
   real, parameter :: epim1  = epi-1.       ! that 0.61 term of virtual temp.   [    kg/kg]
   real, parameter :: toodry = 1.e-8        ! Minimum acceptable mixing ratio.  [    kg/kg]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Liquid water properties                                                               !
   !---------------------------------------------------------------------------------------!
   real, parameter :: wdns     = 1.000e3    ! Liquid water density              [    kg/m�]
   real, parameter :: wdnsi    = 1./wdns    ! Inverse of liquid water density   [    m�/kg]
   real, parameter :: cliq     = 4.186e3    ! Liquid water specific heat (Cl)   [   J/kg/K]
   real, parameter :: cliqvlme = wdns*cliq  ! Water heat capacity � water dens. [   J/m�/K]
   real, parameter :: cliqi    = 1./cliq    ! Inverse of water heat capacity    [   kg K/J]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   ! Ice properties                                                                        !
   !---------------------------------------------------------------------------------------!
   real, parameter :: idns     = 9.167e2      ! "Hard" ice density              [    kg/m�]
   real, parameter :: idnsi    = 1./idns      ! Inverse of ice density          [    m�/kg]
   real, parameter :: cice     = 2.093e3      ! Ice specific heat (Ci)          [   J/kg/K]
   real, parameter :: cicevlme = wdns * cice  ! Heat capacity � water density   [   J/m�/K]
   real, parameter :: cicei    = 1. / cice    ! Inverse of ice heat capacity    [   kg K/J]
   !---------------------------------------------------------------------------------------!




   !---------------------------------------------------------------------------------------!
   ! Phase change properties                                                               !
   !---------------------------------------------------------------------------------------!
   real, parameter :: t3ple    = 273.16        ! Water triple point temp. (T3)  [        K]
   real, parameter :: t3plei   = 1./t3ple      ! 1./T3                          [      1/K]
   real, parameter :: es3ple   = 611.65685464  ! Vapour pressure at T3 (es3)    [       Pa]
   real, parameter :: es3plei  = 1./es3ple     ! 1./es3                         [     1/Pa]
   real, parameter :: epes3ple = ep * es3ple   ! epsilon � es3                  [ Pa kg/kg]
   real, parameter :: alvl     = 2.50e6        ! Lat. heat - vaporisation (Lv)  [     J/kg]
   real, parameter :: alvi     = 2.834e6       ! Lat. heat - sublimation  (Ls)  [     J/kg]
   real, parameter :: alli     = 3.34e5        ! Lat. heat - fusion       (Lf)  [     J/kg]
   real, parameter :: allivlme = wdns * alli   ! Lat. heat � water density      [     J/m�]
   real, parameter :: allii    = 1./alli       ! 1/Latent heat - fusion         [     kg/J]
   real, parameter :: aklv     = alvl / cp     ! Lv/Cp                          [        K]
   real, parameter :: akiv     = alvi / cp     ! Ls/Cp                          [        K]
   real, parameter :: qicet3   = cice * t3ple  ! q at triple point, only ice    [     J/kg]
   real, parameter :: qliqt3   = qicet3 + alli ! q at triple point, only liquid [     J/kg]
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    Tsupercool is the temperature of supercooled water that will cause the energy to   !
   ! be the same as ice at 0K. It can be used as an offset for temperature when defining   !
   ! internal energy. The next two methods of defining the internal energy for the liquid  !
   ! part:                                                                                 !
   !                                                                                       !
   !   Uliq = Mliq � [ Cice � T3 + Cliq � (T - T3) + Lf]                                   !
   !   Uliq = Mliq � Cliq � (T - Tsupercool)                                               !
   !                                                                                       !
   !     You may be asking yourself why would we have the ice term in the internal energy  !
   ! definition. The reason is that we can think that internal energy is the amount of     !
   ! energy a parcel received to leave the 0K state to reach the current state (or if you  !
   ! prefer the inverse way, Uliq is the amount of energy the parcel would need to lose to !
   ! become solid at 0K.)                                                                  !
   !---------------------------------------------------------------------------------------!
   real, parameter :: tsupercool = t3ple - (qicet3+alli) * cliqi
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !    eta3ple is a constant related to the triple point that is used to find enthalpy    !
   ! when the equilibrium temperature is above t3ple, whereas cimcp is the difference      !
   ! between the heat capacity of ice and vapour, which is assumed to be the same as the   !
   ! dry air, for simplicity.                                                              !
   !---------------------------------------------------------------------------------------!
   real, parameter :: eta3ple = (cice - cliq) * t3ple + alvi
   real, parameter :: cimcp   =  cice - cp
   real, parameter :: clmcp   =  cliq - cp
   !---------------------------------------------------------------------------------------!



   !---------------------------------------------------------------------------------------!
   !     Minimum temperature for computing the condensation effect of temperature on       !
   ! theta_il, thetae_iv, and associates. Below this temperature, assuming the latent      !
   ! heats as constants becomes a really bad assumption. See :                             !
   !                                                                                       !
   ! Tripoli, J. T.; and Cotton, W.R., 1981: The use of ice-liquid water potential temper- !
   !    ature as a thermodynamic variable in deep atmospheric models. Mon. Wea. Rev.,      !
   !    v. 109, 1094-1102.                                                                 !
   !---------------------------------------------------------------------------------------!
   real, parameter :: ttripoli  = 253.        ! "Tripoli-Cotton" temp. (Ttr)    [        K]
   real, parameter :: htripoli  = cp*ttripoli ! Sensible enthalpy at T=Ttr      [     J/kg]
   real, parameter :: htripolii = 1./htripoli ! 1./htripoli                     [     kg/J]
   !---------------------------------------------------------------------------------------!

#endif

   !---------------------------------------------------------------------------------------!
   ! Unit conversion, it must be defined locally even for coupled runs.                    !
   !---------------------------------------------------------------------------------------!
   real, parameter :: umol_2_kgC     = 1.20107e-8           ! �mol(CO2)   => kg(C)
   real, parameter :: kgC_2_umol     = 1. / umol_2_kgC      ! kg(C)       => �mol(CO2)
   real, parameter :: kgom2_2_tonoha = 10.                  ! kg(C)/m�    => ton(C)/ha
   real, parameter :: tonoha_2_kgom2 = 0.1                  ! ton(C)/ha   => kg(C)/m�
   real, parameter :: umols_2_kgCyr  = umol_2_kgC * yr_sec  ! �mol(CO2)/s => kg(C)/yr
   real, parameter :: kgCday_2_umols = kgC_2_umol / day_sec ! kg(C)/day   => �mol(CO2)/s
   !---------------------------------------------------------------------------------------!


   !---------------------------------------------------------------------------------------!
   !    Double precision version of all constants used in Runge-Kutta.                     !
   !---------------------------------------------------------------------------------------!
   real(kind=8), parameter :: pi18            = dble(pi1           )
   real(kind=8), parameter :: halfpi8         = dble(halfpi        )
   real(kind=8), parameter :: twopi8          = dble(twopi         )
   real(kind=8), parameter :: sqrtpii8        = dble(sqrtpii       )
   real(kind=8), parameter :: pio1808         = dble(pio180        )
   real(kind=8), parameter :: pi48            = dble(pi4           )
   real(kind=8), parameter :: pio48           = dble(pio4          )
   real(kind=8), parameter :: srtwo8          = dble(srtwo         )
   real(kind=8), parameter :: srthree8        = dble(srthree       )
   real(kind=8), parameter :: sqrt2o28        = dble(sqrt2o2       )
   real(kind=8), parameter :: srtwoi8         = dble(srtwoi        )
   real(kind=8), parameter :: srthreei8       = dble(srthreei      )
   real(kind=8), parameter :: onethird8       = dble(onethird      )
   real(kind=8), parameter :: twothirds8      = dble(twothirds     )
   real(kind=8), parameter :: onesixth8       = dble(onesixth      )
   real(kind=8), parameter :: stefan8         = dble(stefan        )
   real(kind=8), parameter :: boltzmann8      = dble(boltzmann     )
   real(kind=8), parameter :: t008            = dble(t00           )
   real(kind=8), parameter :: rmol8           = dble(rmol          )
   real(kind=8), parameter :: volmol8         = dble(volmol        )
   real(kind=8), parameter :: volmoll8        = dble(volmoll       )
   real(kind=8), parameter :: mmdry8          = dble(mmdry         )
   real(kind=8), parameter :: mmh2o8          = dble(mmh2o         )
   real(kind=8), parameter :: mmco28          = dble(mmco2         )
   real(kind=8), parameter :: mmdoc8          = dble(mmdoc         )
   real(kind=8), parameter :: mmcod8          = dble(mmcod         )
   real(kind=8), parameter :: mmdry10008      = dble(mmdry1000     )
   real(kind=8), parameter :: mmcod1em68      = dble(mmcod1em6     )
   real(kind=8), parameter :: mmdryi8         = dble(mmdryi        )
   real(kind=8), parameter :: mmco2i8         = dble(mmco2i        )
   real(kind=8), parameter :: yr_day8         = dble(yr_day        )
   real(kind=8), parameter :: day_sec8        = dble(day_sec       )
   real(kind=8), parameter :: day_hr8         = dble(day_hr        )
   real(kind=8), parameter :: hr_sec8         = dble(hr_sec        )
   real(kind=8), parameter :: min_sec8        = dble(min_sec       )
   real(kind=8), parameter :: vonk8           = dble(vonk          )
   real(kind=8), parameter :: grav8           = dble(grav          )
   real(kind=8), parameter :: erad8           = dble(erad          )
   real(kind=8), parameter :: erad28          = dble(erad2         )
   real(kind=8), parameter :: p008            = dble(p00           )
   real(kind=8), parameter :: p00i8           = dble(p00i          )
   real(kind=8), parameter :: p00k8           = dble(p00k          )
   real(kind=8), parameter :: p00ki8          = dble(p00ki         )
   real(kind=8), parameter :: rdry8           = dble(rdry          )
   real(kind=8), parameter :: rdryi8          = dble(rdryi         )
   real(kind=8), parameter :: cp8             = dble(cp            )
   real(kind=8), parameter :: cpog8           = dble(cpog          )
   real(kind=8), parameter :: rocp8           = dble(rocp          )
   real(kind=8), parameter :: cpor8           = dble(cpor          )
   real(kind=8), parameter :: cpi8            = dble(cpi           )
   real(kind=8), parameter :: cpi48           = dble(cpi4          )
   real(kind=8), parameter :: rh2o8           = dble(rh2o          )
   real(kind=8), parameter :: gorh2o8         = dble(gorh2o        )
   real(kind=8), parameter :: ep8             = dble(ep            )
   real(kind=8), parameter :: epi8            = dble(epi           )
   real(kind=8), parameter :: epim18          = dble(epim1         )
   real(kind=8), parameter :: toodry8         = dble(toodry        )
   real(kind=8), parameter :: wdns8           = dble(wdns          )
   real(kind=8), parameter :: wdnsi8          = dble(wdnsi         )
   real(kind=8), parameter :: cliq8           = dble(cliq          )
   real(kind=8), parameter :: cliqvlme8       = dble(cliqvlme      )
   real(kind=8), parameter :: cliqi8          = dble(cliqi         )
   real(kind=8), parameter :: idns8           = dble(idns          )
   real(kind=8), parameter :: idnsi8          = dble(idnsi         )
   real(kind=8), parameter :: cice8           = dble(cice          )
   real(kind=8), parameter :: cicevlme8       = dble(cicevlme      )
   real(kind=8), parameter :: cicei8          = dble(cicei         )
   real(kind=8), parameter :: t3ple8          = dble(t3ple         )
   real(kind=8), parameter :: t3plei8         = dble(t3plei        )
   real(kind=8), parameter :: es3ple8         = dble(es3ple        )
   real(kind=8), parameter :: es3plei8        = dble(es3plei       )
   real(kind=8), parameter :: epes3ple8       = dble(epes3ple      )
   real(kind=8), parameter :: alvl8           = dble(alvl          )
   real(kind=8), parameter :: alvi8           = dble(alvi          )
   real(kind=8), parameter :: alli8           = dble(alli          )
   real(kind=8), parameter :: allivlme8       = dble(allivlme      )
   real(kind=8), parameter :: allii8          = dble(allii         )
   real(kind=8), parameter :: aklv8           = dble(aklv          )
   real(kind=8), parameter :: akiv8           = dble(akiv          )
   real(kind=8), parameter :: qicet38         = dble(qicet3        )
   real(kind=8), parameter :: qliqt38         = dble(qliqt3        )
   real(kind=8), parameter :: tsupercool8     = dble(tsupercool    )
   real(kind=8), parameter :: eta3ple8        = dble(eta3ple       )
   real(kind=8), parameter :: cimcp8          = dble(cimcp         )
   real(kind=8), parameter :: clmcp8          = dble(clmcp         )
   real(kind=8), parameter :: ttripoli8       = dble(ttripoli      )
   real(kind=8), parameter :: htripoli8       = dble(htripoli      )
   real(kind=8), parameter :: htripolii8      = dble(htripolii     )
   real(kind=8), parameter :: umol_2_kgC8     = dble(umol_2_kgC    )
   real(kind=8), parameter :: kgom2_2_tonoha8 = dble(kgom2_2_tonoha)
   real(kind=8), parameter :: tonoha_2_kgom28 = dble(tonoha_2_kgom2)
   !---------------------------------------------------------------------------------------!



end Module consts_coms
