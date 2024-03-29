### LOAD SETTINGS ###
library(XML)
if(interactive()){
  user <- Sys.getenv('USER')
  if(user == 'ed'){
    settings.file = '~/in/ebifarm/fast/pavi.xml'
  } else if(user == 'davids14') {
    settings.file = '~/pecan/tundra.xml'
  } else {
    paste('please specify settings file in write.configs.R')
  }
} else {
  settings.file <- Sys.getenv("PECANSETTINGS")
}
settings.xml <- xmlParse(settings.file)
settings <- xmlToList(settings.xml)
outdir   <- settings$outdir
host <- settings$run$host

if(!is.null(settings$Rlib)){ .libPaths(settings$Rlib)} 
library(PECAn)

pft.names <- unlist(xpathApply(settings.xml, '//pfts//pft//name', xmlValue))
outdirs <- unlist(xpathApply(settings.xml, '//pfts//pft//outdir', xmlValue))

trait.samples <- list()
sa.samples <- list()
ensemble.samples <- list()

## Remove existing outputs. 

todelete <- dir(paste(settings$pfts$pft$outdir, 'out/', sep = ''),
                c('ED2INc.*','c.*'),
                recursive=TRUE, full.names = TRUE)
if(length(todelete>0)) file.remove(todelete)

filename.root <- get.run.id('c.','ebifarm.pavi')

if(host$name == 'localhost'){
  if(length(dir(host$rundir, pattern = filename.root)) > 0) {
    old.outputs <- dir(host$outdir,
                         pattern = paste(filename.root, "*[^log]", sep = ''), 
                         recursive=TRUE, full.names = TRUE)
    old.completion.indicators <- dir(host$outdir,
                                     pattern = "*-finished", 
                                     recursive=TRUE, full.names = TRUE) 

    file.remove(c(old.outputs, old.completion.indicators))
  }
} else {
  old.configs  <- system(paste("ssh ", host$name, " 'ls ", host$rundir, "*", filename.root, "*[^log]'", sep = ''), intern = TRUE)
  old.outputs <- system(paste("ssh ", host$name, " 'ls ", host$outdir, "*'", sep = ''), intern = TRUE)
  files <- c(old.configs, old.outputs)
  if(length(files) > 0 ) {
    todelete <- files[-grep('log', files)]
    system(paste("ssh -T ", host$name,
                 " 'for f in ", paste(todelete, collapse = ' '),"; do rm $f; done'",sep=''))
  }
}

## Load priors and posteriors

for (i in seq(pft.names)){
  load(paste(outdirs[i], 'prior.distns.Rdata', sep=''))

  if("trait.mcmc.Rdata" %in% dir(outdirs)) {
    load(paste(outdirs[i], 'trait.mcmc.Rdata', sep=''))
  }

  pft.name <- pft.names[i]

  ## when no ma for a trait, sample from  prior
  ## trim all chains to shortest mcmc chain, else 20000 samples
  if(exists('trait.mcmc')) {
    traits <- names(trait.mcmc)
    samples.num <- min(sapply(trait.mcmc, function(x) nrow(as.matrix(x))))
  } else {
    traits <- NA
    samples.num <- 20000
  }

  priors <- rownames(prior.distns)
  for (prior in priors) {
    if (prior %in% traits) {
      samples <- as.matrix(trait.mcmc[[prior]][,'beta.o'])
    } else {
      samples <- get.sample(prior.distns[prior,], samples.num)
    }
    trait.samples[[pft.name]][[prior]] <- samples
  }

  ## subset the trait.samples to ensemble size using Halton sequence 
  if('ensemble' %in% names(settings) && settings$ensemble$size > 0) {
    ensemble.samples[[pft.name]] <- get.ensemble.samples(settings$ensemble$size, trait.samples[[pft.name]])
    write.ensemble.configs(settings$pfts[[i]], ensemble.samples[[pft.name]], 
                           host, outdir, settings)
  }
  

  if('sensitivity.analysis' %in% names(settings)) {
    if( is.null(settings$sensitivity.analysis)) {
      print(paste('sensitivity analysis settings are NULL'))
    } else {
      quantiles <- get.quantiles(settings$sensitivity.analysis$quantiles)
      sa.samples[[pft.name]] <-  get.sa.samples(trait.samples[[pft.name]], quantiles)
      write.sa.configs(settings$pfts[[i]], sa.samples[[pft.name]], 
                       host, outdir, settings)
    }
  }
}

save(ensemble.samples, trait.samples, sa.samples, settings,
     file = paste(outdir, 'samples.Rdata', sep=''))

## Make outdirectory, send samples to outdir

if(host$name == 'localhost'){
  if(!host$outdir == outdir) {
    dir.create(host$outdir)
    file.copy(from = paste(outdir, 'samples.Rdata', sep=''),
              to   = paste(host$outdir, 'samples.Rdata', sep = ''),
              overwrite = TRUE)
  }
} else {  
  mkdir.cmd <- paste("'if ! ls ", host$outdir, " > /dev/null ; then mkdir -p ", host$outdir," ; fi'",sep='')
  system(paste("ssh", host$name, mkdir.cmd))
  system(paste('rsync -routi ', paste(outdir, 'samples.Rdata', sep=''),
               paste(host$name, ':', host$outdir, sep='')))
}
