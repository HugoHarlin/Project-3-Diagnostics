diagnose = function(network, cases)
{
  
  result_probs = matrix(0,10,4)
  
  # iterating for each case
  for (x in 1:10) {
    
    samples = data.frame(Pn = rep(0,1000), Te = rep(0,1000), VTB = rep(0,1000), TB = rep(0,1000), Sm = rep(0,1000),
                         LC = rep(0,1000), Br = rep(0,1000), XR = rep(0,1000), Dy = rep(0,1000))
    
    samples[1,] = cases[x,]
    samples$Pn[1] = sample(0:1,1)
    samples$TB[1] = sample(0:1,1)
    samples$LC[1] = sample(0:1,1)
    samples$Br[1] = sample(0:1,1)
    
    # loop generating 100 samples
    for (i in 2:1000) {
      
      temp = samples[i-1,]
      #show("temp before iteration: ")
      #show(temp)
      
      for (j in c("Pn","TB","LC","Br")) {
        # we evalute the configuration with changed parameter j
        probTemp_old = 0
        probTemp_old = network$Pn[temp$Pn+1]*network$Sm[temp$Sm+1]*network$VTB[temp$VTB+1]
        probTemp_old = probTemp_old*dnorm(temp$Te,network$Te[temp$Pn+1,1],network$Te[temp$Pn+1,2])
        probTemp_old = probTemp_old*network$TB[temp$VTB+1,temp$TB+1]
        probTemp_old = probTemp_old*network$LC[temp$Sm+1,temp$LC+1]
        probTemp_old = probTemp_old*network$Br[temp$Sm+1,temp$Br+1]
        probTemp_old = probTemp_old*network$Dy[(temp$LC)*2+temp$Br+1,temp$Dy+1]
        probTemp_old = probTemp_old*network$XR[(temp$Pn)*4 + (temp$TB)*2+temp$LC+1,temp$XR+1]
        #show("probTemp_old: ")
        #show(probTemp_old)
        
        # we assign a new value to the unknown parameter j
        if(samples[[j]][i-1] == 0){
          temp[[j]] = 1
        }else{
          temp[[j]] = 0
        }
        
        # we evalute the configuration with changed parameter j
        probTemp_new = 0
        probTemp_new = network$Pn[temp$Pn+1]*network$Sm[temp$Sm+1]*network$VTB[temp$VTB+1]
        probTemp_new = probTemp_new*dnorm(temp$Te,network$Te[temp$Pn+1,1],network$Te[temp$Pn+1,2])
        probTemp_new = probTemp_new*network$TB[temp$VTB+1,temp$TB+1]
        probTemp_new = probTemp_new*network$LC[temp$Sm+1,temp$LC+1]
        probTemp_new = probTemp_new*network$Br[temp$Sm+1,temp$Br+1]
        probTemp_new = probTemp_new*network$Dy[(temp$LC)*2+temp$Br+1,temp$Dy+1]
        probTemp_new = probTemp_new*network$XR[(temp$Pn)*4 + (temp$TB)*2+temp$LC+1,temp$XR+1]
       # show("probTemp_new: ")
        #show(probTemp_new)
        
        if(probTemp_new < probTemp_old){
          if(runif(1) > probTemp_new/probTemp_old ){
            if(temp[[j]] == 0){
              temp[[j]] = 1
            }else{
              temp[[j]] = 0
            }
          }
        }
        samples[i,] = temp
        #readline(prompt="Press [enter] to continue")
      }
      
      #show("Temp after iteration")
      #show(temp)
      #show("--------------------------------")
    }

    result_probs[x,1] = sum(samples$Pn[101:1000])/900
    result_probs[x,2] = sum(samples$TB[101:1000])/900
    result_probs[x,3] = sum(samples$LC[101:1000])/900
    result_probs[x,4] = sum(samples$Br[101:1000])/900
    #show(result_probs)
      
  }
  return(result_probs)
}