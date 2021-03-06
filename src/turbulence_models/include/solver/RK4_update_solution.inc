!include in solver.f90

      select case (turbulence)

          case ("none")
              !include nothing
              continue

          case ("sst", "sst2003")
              include "turbulence_models/sst/solver/RK4_update_solution.inc"

          case DEFAULT
              call dmsg(5, "turbulence_models/include/solver", "RK4_update_solution", &
                        "ERROR: Turbulence model not recognised")
              STOP

      end select
