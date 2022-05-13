## 0.8.9
### Bugs
* fix handling NA values in factor columns

## 0.8.8
### Bugs
* fix a bug that occurs when there are NAs in x/y mappings (submitted by @zzawadz as #108)

## 0.8.7
### Bugs
* fix ghost tooltips when user don't privide data for tooltips
* fix case when old tooltip data is stored in database

## 0.8.6
### Bugs
* fix handling ghost points on the plots

## 0.8.5
### Bugs
* fix invalid detection of plots on box plot

## 0.8.4
### Bugs
* fix when generating tooltips and there are no points on the plot

## 0.8.3
### Bugs
* fix issue on bar plot with horizontal rectangle occupy whole width and the tooltip wa cut off (by left edge)

## 0.8.2
### Bugs
* fix broken resize shiny event (used by execOnResize on renderPlot)

## 0.8.1
### Bugs
* fix random tooltip rendering issue (when SVG was not yet properly rendered)

## 0.8.0
### Features
* Implementation of tooltips for bar plots

## 0.7.1
### Bugs
* Handle case when there are no valid points for geom coordinates

## 0.7.0
### Features
* add support for bar plots

## 0.6.1
### Bugs
* fix tooltips for confidence interval boxes

## 0.6.0
### Features
* parametrize tooltip distance tolerance value

## 0.5.1
### Bugs
* fix issue when plot changes the size

## 0.5.0
### Features
* allow to set min and max width of the tooltips
### Bugs
* fix missing tooltips on some black & white points (created from shapes)

## 0.4.3
### Bugs
* fix handlig errors when SVG plot is replaced
* fix adding proximity event

## 0.4.2
### Bugs
* fix shrinking tooltips
* fix issue on Safari

## 0.4.1
### Bugs
* cleanup the events after rendering ggtips without tooltips
* fix points position calculation when you scroll while cursor is on top of the plot

## 0.4.0
### Features
* Performance improvements
### Bugs
* Add addAttributes parameter to getSvgAndTooltipdata to fix unused argument errors
* Fix the ordering of plot data for some trellises
* Optimize the workflow
* Bump up minimal required versions of R and ggplot2

## 0.3.5
### Features
* Allow to set transparent plots
### Bugs
* Fix error when tooltip function return empty list
* Workaround for unfilled shapes

## 0.3.4
### Features
* NULL `varDict` turns off rendering tooltips

### Bugs
* Handling NA values
* Flipped coords
* Plots with custom ranges
* Multi-faceted trellises

## 0.3.3
* Updated MIT license

## 0.3.2
### Bugs
* fix tooltip offset with scrollbar on content
* fix issue on Firefox [#36](https://github.com/Roche/ggtips/issues/36)
* add missing height parameter
* enable polygon points for tooltips

## 0.3.1
### Bugs
* argument height

## 0.3.0
### Features
* improved API `ggtips::plotWithTooltips`

## 0.2.1
### Bugs
* fix hiding tooltip when hover out the point

## 0.2.0
### Features
* customGrob option
### Bugs
* fix arrow in FireFox [#15](https://github.com/Roche/ggtips/issues/15)
* compatibility fix for GGPlot 2 and 3 [#17](https://github.com/Roche/ggtips/pull/17)
* fix error with multiple panels and removed middle one [#18](https://github.com/Roche/ggtips/pull/18)
* fix right aligned tooltip [#19](https://github.com/Roche/ggtips/pull/19)

## 0.1.0
* Initial version
