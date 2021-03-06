get.efficiency <- function(txt.df, time.df, data.name) {
	if (data.name == "Short" || data.name == "Medium") {
		Efficiency.df = get.simulated.efficiency(txt.df, time.df)
	}

	if (data.name == "RSV2") {
		Efficiency.df = get.RSV2.efficiency(txt.df, time.df)
	}

	if (data.name == "Shankarappa") {
		Efficiency.df = get.Shankarappa.efficiency(txt.df, time.df)
	}

	if (data.name == "anolis") {
		Efficiency.df = get.anolis.efficiency(txt.df, time.df)
	}
	
	if (data.name == "primates") {
		Efficiency.df = get.primates.efficiency(txt.df, time.df)
	}
	return(Efficiency.df)
}



get.simulated.efficiency <- function(txt.df, time.df) {
  posterior = txt.df$posterior.ESS / time.df
  likelihood = txt.df$likelihood.ESS / time.df
  prior = txt.df$prior.ESS / time.df
  birth.rate = txt.df$BirthRate.ESS / time.df
  tree.height = txt.df$Tree.height.ESS / time.df
  tree.length = txt.df$Tree.treeLength.ESS / time.df
  ucld.stdev = txt.df$ucldStdev.ESS / time.df
  rate.mean = txt.df$rate.mean.ESS / time.df
  rate.variance = txt.df$rate.variance.ESS / time.df
  rate.coeff = txt.df$rate.coefficientOfVariation.ESS / time.df
  kappa = txt.df$kappa.ESS / time.df
  frequency1 = txt.df$freqParameter.1.ESS / time.df
  frequency2 = txt.df$freqParameter.2.ESS / time.df
  frequency3 = txt.df$freqParameter.3.ESS / time.df
  frequency4 = txt.df$freqParameter.4.ESS / time.df
  data = data.frame(cbind(posterior,likelihood,prior,birth.rate,tree.height,tree.length,ucld.stdev,rate.mean,rate.variance,rate.coeff,kappa,frequency1,frequency2,frequency3,frequency4))
  return (data)
}

get.txt.folder <- function(data.name,model) {
  if (data.name == "simulated") {
    p = paste0("Short",model,"/output/output_Short",model,"20taxa_")
  } else {
    if (model == "Cons"){
      model.type = "2"
    } else {
      model.type = "1"
    }
    p <- paste0(data.name,model,"/output/output_",data.name,model.type,"_")
  }
  return (p)
}

get.RSV2.efficiency <- function(txt.df, time.df) {
  posterior = txt.df$posterior.ESS / time.df
  likelihood = txt.df$likelihood.ESS / time.df
  prior = txt.df$prior.ESS / time.df
  pop.size = txt.df$popSize.ESS / time.df
  tree.height = txt.df$Tree.height.ESS / time.df
  tree.length = txt.df$Tree.treeLength.ESS / time.df
  ucld.stdev = txt.df$ucldStdev.ESS / time.df
  ucld.mean = txt.df$ucldMean.ESS / time.df
  rate.mean = txt.df$rate.mean.ESS / time.df
  rate.variance = txt.df$rate.variance.ESS / time.df
  rate.coeff = txt.df$rate.coefficientOfVariation.ESS / time.df
  kappa = txt.df$kappa.ESS / time.df
  frequency1 = txt.df$freqParameter.1.ESS / time.df
  frequency2 = txt.df$freqParameter.2.ESS / time.df
  frequency3 = txt.df$freqParameter.3.ESS / time.df
  frequency4 = txt.df$freqParameter.4.ESS / time.df
  data = data.frame(cbind(posterior,likelihood,prior,pop.size,tree.height,tree.length,ucld.stdev,ucld.mean,rate.mean,rate.variance,rate.coeff,kappa,frequency1,frequency2,frequency3,frequency4))
  return (data)
}

get.Shankarappa.efficiency <- function(txt.df, time.df) {
  posterior = txt.df$posterior.ESS / time.df
  likelihood = txt.df$likelihood.ESS / time.df
  prior = txt.df$prior.ESS / time.df
  pop.size = txt.df$popSize.ESS / time.df
  tree.height = txt.df$Tree.height.ESS / time.df
  tree.length = txt.df$Tree.treeLength.ESS / time.df
  ucld.stdev = txt.df$ucldStdev.ESS / time.df
  ucld.mean = txt.df$ucldMean.ESS / time.df
  rate.mean = txt.df$rate.mean.ESS / time.df
  rate.variance = txt.df$rate.variance.ESS / time.df
  rate.coeff = txt.df$rate.coefficientOfVariation.ESS / time.df
  kappa = txt.df$kappa.ESS / time.df
  frequency1 = txt.df$freqParameter.1.ESS / time.df
  frequency2 = txt.df$freqParameter.2.ESS / time.df
  frequency3 = txt.df$freqParameter.3.ESS / time.df
  frequency4 = txt.df$freqParameter.4.ESS / time.df
  data = data.frame(cbind(posterior,likelihood,prior,pop.size,tree.height,tree.length,ucld.stdev,ucld.mean,rate.mean,rate.variance,rate.coeff,kappa,frequency1,frequency2,frequency3,frequency4))
  return (data)
}

get.anolis.efficiency <- function(txt.df, time.df) {
  posterior = txt.df$posterior.ESS / time.df
  likelihood = txt.df$likelihood.ESS / time.df
  prior = txt.df$prior.ESS / time.df
  birth.rate = txt.df$BDBirthRate.ESS / time.df
  death.rate = txt.df$BDDeathRate.ESS / time.df
  tree.height = txt.df$Tree.height.ESS / time.df
  tree.length = txt.df$Tree.treeLength.ESS / time.df
  ucld.stdev = txt.df$ucldStdev.ESS / time.df
  rate.mean = txt.df$rate.mean.ESS / time.df
  rate.variance = txt.df$rate.variance.ESS / time.df
  rate.coeff = txt.df$rate.coefficientOfVariation.ESS / time.df
  kappa = txt.df$kappa.ESS / time.df
  frequency1 = txt.df$freqParameter.1.ESS / time.df
  frequency2 = txt.df$freqParameter.2.ESS / time.df
  frequency3 = txt.df$freqParameter.3.ESS / time.df
  frequency4 = txt.df$freqParameter.4.ESS / time.df
  data = data.frame(cbind(posterior,likelihood,prior,birth.rate,death.rate,tree.height,tree.length,ucld.stdev,rate.mean,rate.variance,rate.coeff,kappa,frequency1,frequency2,frequency3,frequency4))
  return (data)
}

get.primates.efficiency <- function(txt.df, time.df) {
  posterior = txt.df$posterior.ESS / time.df
  likelihood = txt.df$likelihood.ESS / time.df
  prior = txt.df$prior.ESS / time.df
  tree.height = txt.df$Tree.height.ESS / time.df
  tree.length = txt.df$Tree.treeLength.ESS / time.df
  ucld.stdev = txt.df$ucldStdev.ESS / time.df
  birth.rate = txt.df$birthRate.ESS / time.df
  rate.mean = txt.df$rate.mean.ESS / time.df
  rate.variance = txt.df$rate.variance.ESS / time.df
  rate.coeff = txt.df$rate.coefficientOfVariation.ESS / time.df
  kappa = txt.df$kappa.ESS / time.df
  frequency1 = txt.df$freqParameter.1.ESS / time.df
  frequency2 = txt.df$freqParameter.2.ESS / time.df
  frequency3 = txt.df$freqParameter.3.ESS / time.df
  frequency4 = txt.df$freqParameter.4.ESS / time.df
  data = data.frame(cbind(posterior,likelihood,prior,birth.rate,tree.height,tree.length,ucld.stdev,rate.mean,rate.variance,rate.coeff,kappa,frequency1,frequency2,frequency3,frequency4))
  return (data)
}
