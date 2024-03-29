##' Approximate the posterior MCMC with a closed form pdf
##'
##' returns priors where posterior MCMC are missing
##' @title Approximate posterior
##' @param trait.mcmc meta analysis outputs
##' @param priors dataframe of priors used in meta analysis
##' @param trait.data data used in meta-analysis (used for plotting)
##' @param outdir directory in which to plot results
##' @return posteriors data frame, similar to priors, but with closed form pdfs fit to meta-analysis results  
##' @author David LeBauer, Carl Davidson, Mike Dietze
approx.posterior <- function(trait.mcmc,priors,trait.data=NULL,outdir=NULL){
  ##initialization
  posteriors = priors
  do.plot = !is.null(outdir)
  if(do.plot){
    pdf(paste(outdir,"posteriors.pdf",sep=""))
  }
  
  ##loop over traits
  for(trait in names(trait.mcmc)){
    
    dat  <- trait.mcmc[[trait]]
    vname <- colnames(dat[[1]])
    dat <- as.vector(as.array(dat)[,which(vname == "beta.o"),])
    pdist = priors[trait,"distn"]
    pparm = as.numeric(priors[trait,2:3])
    ptrait = trait
    if(trait == "Vm0") trait = "Vcmax"

    fp <- function(x){
      cl <- call(paste("d",priors[ptrait,"distn"],sep=""),x,priors[ptrait,"parama"],priors[ptrait,"paramb"])
      eval(cl)
    }
    
    ## first determine the candidate set of models based on any range restrictions
    zerobound = c("exp","gamma","lnorm")#,"weibull")
    if(pdist %in% "beta"){
      fit = fitdistr(dat,"beta",list(shape1=1,shape2=1))
      if(do.plot){
        x = seq(0,1,length=1000)
        plot(density(dat),col=2,lwd=2,main=trait)
        if(!is.null(trait.data)){
          rug(trait.data[[trait]]$Y, lwd = 2) 
          #hist(trait.data[[trait]]$Y,probability=TRUE,
          #     breaks = sqrt(nrow(trait.data[[trait]])),
          #     add=TRUE,border="purple")
        }
        lines(x,dbeta(x,fit$estimate[1],fit$estimate[2]),lwd=2,type='l')
        lines(x,dbeta(x,pparm[1],pparm[2]),lwd=3,type='l',col=3)
        legend("topleft",legend=c("data","prior","post","approx"),col=c("purple",3,2,1),lwd=2)
      }
      posteriors[trait,"parama"] = fit$estimate[1]
      posteriors[trait,"paramb"] = fit$estimate[2]
    } else if(pdist %in% zerobound | (pdist == "unif" & pparm[1] > 0)){

      fit = list()
      fit[[1]] = fitdistr(dat,"exponential")
#      fit[[2]] = fitdistr(dat,"f",list(df1=10,df2=2*mean(dat)/(max(mean(dat)-1,1))))
      fit[[2]] = fitdistr(dat,"gamma")
      fit[[3]] = fitdistr(dat,"lognormal")
#      fit[[4]] = fitdistr(dat,"weibull")
      fit[[4]] = fitdistr(dat,"normal")
      fparm <- lapply(fit,function(x){as.numeric(x$estimate)})
      fAIC  <- lapply(fit,function(x){AIC(x)})
      
      bestfit = which.min(fAIC)
      posteriors[ptrait,"distn"]  = c(zerobound,"norm")[bestfit]
      posteriors[ptrait,"parama"] = fit[[bestfit]]$estimate[1]
      if(bestfit == 1){
        posteriors[ptrait,"paramb"] = NA
      }else{
        posteriors[ptrait,"paramb"] = fit[[bestfit]]$estimate[2]
      }
      
      if(do.plot){
        f <- function(x){
          cl <- call(paste("d",posteriors[ptrait,"distn"],sep=""),x,posteriors[ptrait,"parama"],posteriors[ptrait,"paramb"])
          eval(cl)
        }
        fq <- function(x){
          cl <- call(paste("q",priors[ptrait,"distn"],sep=""),x,priors[ptrait,"parama"],priors[ptrait,"paramb"])
          eval(cl)
        }        
        qbounds = fq(c(0.01,0.99))
        x = seq(qbounds[1],qbounds[2],length=1000)
        rng = range(dat)
        if(!is.null(trait.data)) rng = range(trait.data[[trait]]$Y)
        
        plot(density(dat),col=2,lwd=2,main=trait,xlim=rng)
        if(!is.null(trait.data)) {
          rug(trait.data[[trait]]$Y, lwd = 2) 
          ##hist(trait.data[[trait]]$Y,
          ##     breaks = sqrt(nrow(trait.data[[trait]])),
          ##     probability=TRUE,add=TRUE,border="purple")
        }
        lines(x,f(x),lwd=2,type='l')
        lines(x,fp(x),lwd=3,type='l',col=3)
        legend("topleft",legend=c("data","prior","post","approx"),col=c("purple",3,2,1),lwd=2)
      }
      
    } else {
    
      ## default: NORMAL
      posteriors[trait,"distn"]  = "norm"
      posteriors[trait,"parama"] = mean(dat)
      posteriors[trait,"paramb"] = sd(dat)
      if(do.plot){
        rng = range(dat)
        if(!is.null(trait.data)) rng = range(trait.data[[trait]]$Y)
        x = seq(rng[1],rng[2],length=1000)
        plot(density(dat),col=2,lwd=2,main=trait,xlim=rng)
        if(!is.null(trait.data)) {
          rug(trait.data[[trait]]$Y, lwd = 2) 
          ## hist(trait.data[[trait]]$Y,probability=TRUE,
          ##     breaks = sqrt(nrow(trait.data[[trait]])),
          ##     add=TRUE,border="purple")
        }
        lines(x,dnorm(x,mean(dat),sd(dat)),lwd=2,type='l')
        lines(x,fp(x),lwd=3,type='l',col=3)
        legend("topleft",legend=c("data","prior","post","approx"),col=c("purple",3,2,1),lwd=2)
      }
    }
  }  ## end trait loop

  if(do.plot) dev.off()
  
  return(posteriors)
  
}
