library(FFTrees)
library(mlrMBO)
library(drake)
library(mlr)

data(wine)

wine
colnames(wine)
wine$quality <- as.factor(ifelse(wine$quality >= 6, 1, 0))
wine$type <- as.factor(wine$type)
table(wine$quality)

task <- makeClassifTask(id='wine', data=wine, target = "quality")
learner <- makeLearner("classif.ranger", predict.type = "prob")
pars <- makeParamSet(makeIntegerParam(id="mtry", lower = 1, upper = 12),
                     makeIntegerParam(id="min.node.size", lower = 1, upper=15),
                     makeDiscreteParam(id="splitrule", values=c("gini","extratrees")),
                     makeIntegerParam(id="num.random.splits", lower=1, upper = 20,requires =  quote(splitrule == "extratrees"))
)
parallelMap::parallelStartSocket(6)

control = makeMBOControl()
control = setMBOControlTermination(control, iters = 10)
control = setMBOControlInfill(control, crit = makeMBOInfillCritEI())

best_params <- tuneParams(learner = learner,
                          task=task,
                          resampling = makeResampleDesc("CV", iter=4),
                          measures = auc,
                          par.set = pars,
                          control = makeTuneControlMBO(mbo.control = control))

parallelMap::parallelStop()

model <- train(setHyperPars(learner, par.vals = best_params$x), task)

save(model, file = "model.RData")
