
data("recaPrediction")
testset1 <- list()
testset1$prediction <- recaPrediction

mockset <- testset1
mockset$prediction$AgeCategories
mockset$prediction$AgeCategories <- mockset$prediction$AgeCategories[3:13]

context("test makeResultTableRECA: simple run")
all <- makeResultTableRECA(testset1$prediction)
expect_true(all(all$unit == "millions"))

context("test makeResultTableRECA: unit")
u <- makeResultTableRECA(testset1$prediction, unit="kT")
expect_true(all(u$unit == "kT"))

context("test makeResultTableRECA: plusgr")
plusgr6 <- makeResultTableRECA(testset1$prediction, plusGroup=6)
expect_equal(nrow(plusgr6), 5)
expect_equal(plusgr6[1:4,2], all[1:4,2])
expect_equal(sum(plusgr6[5,2]), sum(all[5:13,2]))
expect_equal(sum(plusgr6[,2]), sum(all[,2]))

context("test makeResultTableRECA: plusgr too large")
expect_error(makeResultTableRECA(testset1$prediction, plusGroup=14))
expect_error(makeResultTableRECA(testset1$prediction, plusGroup=0))

context("test makeResultTableRECA: unsupported unit")
expect_error(makeResultTableRECA(testset1$prediction, plusGroup=6, unit="uns"))

context("test makeResultTableRECA: ages not starting at 1")
gr2t6 <- makeResultTableRECA(mockset$prediction, plusGroup=6)
expect_equal(nrow(gr2t6), 3)
expect_equal(gr2t6$age[1], "4")
expect_equal(gr2t6$age[3], "6+")

context("test makeAgeTracesRECA: simple run")
trace <- makeAgeTracesRECA(testset1$prediction)
expect_equal(ncol(trace), 13)
expect_equal(nrow(trace), 50)
expect_true(all(colMeans(trace) == all$total))

context("test makeAgeTracesRECA: plusgr")
plusgr6trace <- makeAgeTracesRECA(testset1$prediction, plusGroup=6)
expect_equal(ncol(plusgr6trace), 5)
expect_equal(nrow(plusgr6trace), 50)
expect_true(all(colMeans(plusgr6trace) == plusgr6$total))
plusgr7trace <- makeAgeTracesRECA(testset1$prediction, plusGroup=7)
expect_equal(ncol(plusgr7trace), 6)
expect_equal(nrow(plusgr7trace), 50)

context("test makeAgeTracesRECA: plusgr too large")
expect_error(makeAgeTracesRECA(testset1$prediction, plusGroup=14))
expect_error(makeAgeTracesRECA(testset1$prediction, plusGroup=0))


context("test makeAgeTracesRECA: unit")
u <- makeAgeTracesRECA(testset1$prediction, unit="number", plusGroup = 6)
expect_true(all(abs(colMeans(u) - (plusgr6$total*1e6))<1e-9))

context("test makeAgeTracesRECA: ages not starting at 1")
gr2t6 <- makeAgeTracesRECA(mockset$prediction, plusGroup=6)
expect_equal(ncol(gr2t6), 3)
expect_equal(names(gr2t6)[1], "4")
expect_equal(names(gr2t6)[3], "6+")


#
# PLot tests (actual plot on NULL-device)
#

pdf(file=NULL)
context("test plot Agetraces")
data(recaPrediction)
plotAgeTraces(recaPrediction, plusGroup=6, nclust = 2)

context("test plot Agetraces, thosuands")
plotAgeTraces(recaPrediction, plusGroup=6, nclust = 2, unit="thousands")

context("test plot Agetraces, weightunit")
plotAgeTraces(recaPrediction, plusGroup=6, nclust = 2, unit="kT")

context("test plot Catch At age")
data(recaPrediction)
plotCatchAtAge(recaPrediction)

context("test plot Catch At age, wiehgtUnit")
plotCatchAtAge(recaPrediction, unit="kg")
dev.off()
