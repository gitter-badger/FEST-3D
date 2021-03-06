!include in solver.f90
            
!            call dmsg(1, 'turbulence_models/sst/solver', 'update_solution')


!               tk_temp = tk(i, j, k) - &
!                            (( (-1 * tk(i, j, k) / density(i, j, k) * &
!                                     mass_residue(i, j, k)) + &
!                             ( TKE_residue(i, j, k) / density(i, j, k)) ) * &
!                            delta_t(i, j, k) / volume(i, j, k))
!
!               tw_temp = tw(i, j, k) - &
!                            (( (-1 * tw(i, j, k) / density(i, j, k) * &
!                                     mass_residue(i, j, k)) + &
!                             ( omega_residue(i, j, k) / density(i, j, k)) ) * &
!                            delta_t(i, j, k) / volume(i, j, k))

      beta = beta1*sst_F1(i,j,k) + (1. - sst_F1(i,j,k))*beta2
              pressure_temp = pressure_temp - &
                              (-(gm-1)*TKE_residue(i,j,k))*&
                              (delta_t(i,j,k)/volume(i,j,k))
              tk_temp = tk(i,j,k) - &
                        (1.*delta_t(i,j,k)/volume(i,j,k))&
                       *(-1.*tk(i,j,k)*mass_residue(i,j,k)/density(i,j,k) &
                       + 1./(1.+bstar*tw(i,j,k)*delta_t(i,j,k))&
                       * (TKE_residue(i,j,k))/density(i,j,k))

              tw_temp = tw(i,j,k) - &
                        (1.*delta_t(i,j,k)/volume(i,j,k))&
                       *(-1.*tw(i,j,k)*mass_residue(i,j,k)/density(i,j,k)&
                       + 1./(1. + 2.*beta*tw(i,j,k)*delta_t(i,j,k))&
                       *(omega_residue(i,j,k))/density(i,j,k))

               if (tk_temp>0.) tk(i, j, k) = tk_temp
               if (tw_temp>0.) tw(i, j, k) = tw_temp
