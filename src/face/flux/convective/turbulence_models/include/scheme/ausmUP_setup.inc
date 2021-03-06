!to  include in schemee.f90/setup_scheme/ausmUP


      select case (turbulence)

          case ("none")
              !include nothing
              continue

          case ("sst", "sst2003")
              include "turbulence_models/sst/scheme/ausmUP_setup.inc"

          case ("kkl")
              include "turbulence_models/kkl/scheme/ausmUP_setup.inc"

          case ("sa", "saBC")
              include "turbulence_models/sa/scheme/ausmUP_setup.inc"

          case ("ke")
              include "turbulence_models/ke/scheme/ausmUP_setup.inc"

          case ("kw")
              include "turbulence_models/kw/scheme/ausmUP_setup.inc"

          case ("des-sst")
              include "turbulence_models/des-sst/scheme/ausmUP_setup.inc"

          case DEFAULT
              call dmsg(5, "turbulence_models/include/scheme", "ausmUP_setup", &
                        "ERROR: Turbulence model not recognised")
              STOP

      end select
