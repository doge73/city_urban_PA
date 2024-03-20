

reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage, vce(cluster family_nb) 
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol, vce(cluster family_nb)
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi , vce(cluster family_nb)

reg log_apu_METhours i.cluster i.sex  age i.edu i.work i.marriage, vce(cluster family_nb) 
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol, vce(cluster family_nb)
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi , vce(cluster family_nb)

reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage, vce(cluster family_nb) 
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol, vce(cluster family_nb)
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi , vce(cluster family_nb)



reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage if sex==1, vce(cluster family_nb) 
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==1, vce(cluster family_nb)
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==1, vce(cluster family_nb)

reg log_apu_METhours i.cluster i.sex  age i.edu i.work i.marriage if sex==1, vce(cluster family_nb) 
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==1, vce(cluster family_nb)
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==1, vce(cluster family_nb)

reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage if sex==1, vce(cluster family_nb) 
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==1, vce(cluster family_nb)
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==1, vce(cluster family_nb)



reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage if sex==2, vce(cluster family_nb) 
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==2, vce(cluster family_nb)
reg log_ltMET i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==2, vce(cluster family_nb)

reg log_apu_METhours i.cluster i.sex  age i.edu i.work i.marriage if sex==2, vce(cluster family_nb) 
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==2, vce(cluster family_nb)
reg log_apu_METhours i.cluster i.sex age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==2, vce(cluster family_nb)

reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage if sex==2, vce(cluster family_nb) 
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol if sex==2, vce(cluster family_nb)
reg log_apu_METhours_commuting i.cluster i.sex  age i.edu i.work i.marriage i.smoking i.substance i.alcohol household1 i.deprivation_bi if sex==2, vce(cluster family_nb)
