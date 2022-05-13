context("Testing content-handling routines")
library(ggplot2)


# Auxiliary functions -----------------------------------------------------

prepareIrisPlot <- function(df, xLimit = NULL, dummy.aes = FALSE) {
  mapping <- if (dummy.aes) {
    aes(x = Sepal.Width, y = Sepal.Length, dummy.aes = Species)
  } else {
    aes(x = Sepal.Width, y = Sepal.Length)
  }
  testPlot <- ggplot(
    data = df,
    mapping = mapping
  ) + 
    geom_point(mapping = aes(colour = Petal.Length)) +
    facet_wrap(~ Species, scales = "fixed")
  
  if (!is.null(xLimit)) {
    testPlot <- testPlot + 
      coord_cartesian(
        xlim = c(0, xLimit),
        expand = TRUE
      )
  }
  list(
    testPlot = testPlot,
    testGrob = ggplot_build(testPlot)
  )
}

prepareMpgPlot <- function(data, facets = "class") {
  ggplot(
    data = data,
    mapping = aes(x = displ, y = cty, colour = cyl)
  ) + 
    geom_point() + 
    geom_hline(yintercept = 20) + 
    facet_wrap(facets = facets)
}

testMpgTooltipData <- function(p, varDict, facetVar = "class") {
  gb <- ggplot_build(p)
  rawData <- ggtips:::getTooltipData(
    plot = p,
    built = gb,
    varDict = varDict,
    plotScales = list(x = "identity", y = "identity"),
    callback = function(x) paste(x$class, x$cty)
  )[[1]]
  
  points <- ggtips::getSvgAndTooltipdata(
    plot = p,
    varDict = varDict,
    width = 300,
    height = 400,
    plotScales = list(x = "identity", y = "identity"),
    addAttributes = TRUE,
    callback = function(x) paste(x$class, x$cty)
  )$data$points[[1]]
  
  # Order `mpg` by the facet variable
  orderedMPG <- if (!is.null(facetVar)) {
    mpg[order(mpg[[facetVar]]), ]
  } else {
    mpg
  }
  
  expect_equal(as.character(rawData$Class), orderedMPG$class)
  expect_equal(as.numeric(rawData$Display), orderedMPG$displ)
  expect_equal(as.integer(rawData$Cty), orderedMPG$cty)
  expect_equal(rawData$.custom, paste(orderedMPG$class, orderedMPG$cty))
  
  mockupHTML <- sprintf(
    "<ul><li>%s %s</li><li>%s: %s</li><li>%s: %s</li><li>%s: %s</li></ul>",
    orderedMPG$class,
    orderedMPG$cty,
    varDict$displ,
    format(orderedMPG$displ, digits = 2),
    varDict$cty,
    orderedMPG$cty,
    varDict$class,
    orderedMPG$class
  )
  expect_equal(mockupHTML, points$tooltip)
}

# Prepare input data ------------------------------------------------------

fullDataPlot <- prepareIrisPlot(iris)
df <- iris
df[c(1, 143), "Sepal.Width"] <- NA
df[c(64, 143), "Sepal.Length"] <- NA
missingDataPlot <- prepareIrisPlot(df)

# Test routines -----------------------------------------------------------

##
test_that("layers", {
  aesth <- ggtips:::getLayerAesthetics(fullDataPlot$testPlot)
  expect_gt(length(aesth), 0)
  expect_equal(
    aesth[[1]],
    list(x = "Sepal.Width", y = "Sepal.Length", colour = "Petal.Length")
  )
  expect_equal(
    ggtips:::getLayerGeom(fullDataPlot$testPlot$layers[[1]]),
    "points"
  )
})

##
test_that("getTooltipData()", {
  varDict <- list(Species = "Species", Sepal.Length = "Sepal Length")
  fullTooltipData <- ggtips:::getTooltipData(
    plot = fullDataPlot$testPlot,
    built = fullDataPlot$testGrob,
    varDict = varDict,
    plotScales = NULL,
    callback = NULL
  )
  expect_is(fullTooltipData, "list")
  expect_length(fullTooltipData, 1L)
  tt <- fullTooltipData[[1]]
  expect_is(tt, "data.frame")
  expect_named(tt, as.character(varDict))
  expect_equal(nrow(tt), nrow(iris))
  
  missingTooltipData <- ggtips:::getTooltipData(
    plot = missingDataPlot$testPlot,
    built = missingDataPlot$testGrob,
    varDict = varDict,
    plotScales = NULL,
    callback = NULL
  )
  expect_is(missingTooltipData, "list")
  expect_length(missingTooltipData, 1L)
  tt <- missingTooltipData[[1]]
  expect_is(tt, "data.frame")
  expect_named(tt, as.character(varDict))
  expect_equal(nrow(tt), 147) # 3 rows with NAs
  
  limitedPlot <- prepareIrisPlot(iris, xLimit = 3, dummy.aes = TRUE)
  limitedTooltipData <- ggtips:::getTooltipData(
    plot = limitedPlot$testPlot,
    built = limitedPlot$testGrob,
    varDict = varDict,
    plotScales = NULL,
    callback = NULL
  )
  expect_is(limitedTooltipData, "list")
  expect_length(limitedTooltipData, 1L)
  tt <- limitedTooltipData[[1]]
  expect_is(tt, "data.frame")
  expect_named(tt, as.character(varDict))
  expect_equal(nrow(tt), 94) # Number of points within range with xlim = 3
})

##
test_that("Custom case", {
  data <- mpg
  data[["class"]] <- factor(data[["class"]])
  data[124, "cyl"] <- NA
  
  p <- prepareMpgPlot(data = data)
  
  varDict <- list(
    displ = "Display",
    cty = "Cty",
    class = "Class"
  )
  data <- ggtips::getSvgAndTooltipdata(
    plot = p,
    varDict = varDict,
    width = 300,
    height = 400,
    plotScales = list(x = "identity", y = "identity"),
    addAttributes = TRUE,
    callback = function(x) paste(x$class, x$cty)
  )
  expect_named(data, c("svg", "data"))
  expect_named(data[["data"]], "points")
  expect_length(data[["data"]][["points"]], 1)
  
  df <- data[["data"]][["points"]][[1]]
  expect_is(df, "data.frame")
  expect_true(nrow(df) == 234)
})

##
test_that("tooltip data", {
  data <- mpg
  
  # Facet by `class`
  data[["class"]] <- factor(data[["class"]])
  data[124, "cyl"] <- NA
  
  p <- prepareMpgPlot(data = data)
  
  varDict <- list(
    displ = "Display",
    cty = "Cty",
    class = "Class"
  )
  testMpgTooltipData(p = p, varDict = varDict)

  # Facet by `manufacturer`  
  data[["manufacturer"]] <- factor(data[["manufacturer"]])
  
  p <- prepareMpgPlot(data = data, facets = "manufacturer")
  
  varDict <- list(
    displ = "Display",
    cty = "Cty",
    class = "Class"
  )
  testMpgTooltipData(p = p, varDict = varDict, facetVar = "manufacturer")
  
  # Don't facet
  p <- prepareMpgPlot(data = data, facets = NULL)
  
  varDict <- list(
    displ = "Display",
    cty = "Cty",
    class = "Class"
  )
  testMpgTooltipData(p = p, varDict = varDict, facetVar = NULL)
})

test_that("Warning message will be displayed when key specified in varDict
  does not exist in data", {
  varDict <- list(
    Sepal.Width = "Existing variable", 
    notExistingKey1 = "Missing variable", 
    notExistingKey2 = "Another missing variable"
  )
  expect_warning(
    object = ggtips:::getTooltipData(
      plot = fullDataPlot$testPlot,
      built = fullDataPlot$testGrob,
      varDict = varDict,
      plotScales = NULL,
      callback = NULL
    ),
    regexp = "The following variables are set as keys in varDict but are missing in plot data: notExistingKey1, notExistingKey2"
  )
})

test_that("NA values in factors are handled correctly", {
  # prepare an iris dataset with species releveled and NA introduced
  irisNA <- iris
  irisNA$Species[irisNA$Species == "versicolor"] <- NA
  irisNA$Species <- relevel(irisNA$Species, "virginica")
  varDict <- list(Species = "Species", Sepal.Length = "Sepal Length")
  # create a ggplot and build it
  testPlot <- ggplot(irisNA, mapping = aes(x = Sepal.Width, y = Sepal.Length)) +
    geom_point(mapping = aes(colour = Species))
  testGrob <- ggplot_build(testPlot)
  # get tooltip data for the plot
  fullTooltipData <- ggtips:::getTooltipData(
    plot = testPlot,
    built = testGrob,
    varDict = varDict,
    plotScales = NULL,
    callback = NULL
  )[[1]]
  fullTooltipData$Species <- as.character(fullTooltipData$Species)
  expectedTooltips <- irisNA[c("Species", "Sepal.Length")]
  expectedTooltips$Species <- as.character(expectedTooltips$Species)
  expectedTooltips$Sepal.Length <- format(expectedTooltips$Sepal.Length)
  names(expectedTooltips) <- c("Species", "Sepal Length")
  expect_equal(fullTooltipData, expectedTooltips)
})
