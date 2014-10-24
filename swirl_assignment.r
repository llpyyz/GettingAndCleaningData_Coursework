##############################
##############################
##############################
#swirl extra credit assignment
##############################
##############################
##############################


########################################
########################################
#Lesson 1 - Manipulating Data With dplyr
########################################
########################################

#Esc to return to R prompt
#bye() from R prompt to save progress and exit swirl
#skip() to skip current question
#play() to experiment in R; swirl ignores this
#nxt() to exit play mode


mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf) 
head(mydf)
library(dplyr)
packageVersion("dplyr") 

# The first step of working with data in dplyr is to load the data into what
# | the package authors call a 'data frame tbl' or 'tbl_df'. Use the following
# | code to create a new tbl_df called cran:
# | 
# | cran <- tbl_df(mydf).

cran <- tbl_df(mydf)
rm("mydf") #get rid of original df, no longer needed
cran #nice printing with tbl_df versus standard df

# According to the "Introduction to dplyr" vignette written by the package
# | authors, "The dplyr philosophy is to have small functions that each do one
# | thing well." Specifically, dplyr supplies five 'verbs' that cover all
# | fundamental data manipulation tasks: select(), filter(), arrange(), mutate(),
# | and summarize().

?manip #docs on these fcns

######################
#select - take columns
######################
select(cran, ip_id, package, country)
# Source: local data frame [225,468 x 3]

   # ip_id      package country
# 1      1    htmltools      US
# 2      2      tseries      US
# 3      3        party      US
# 4      3        Hmisc      US
# 5      4       digest      CA
# 6      3 randomForest      US
# 7      3         plyr      US
# 8      5      whisker      US
# 9      6         Rcpp      CN
# 10     7     hflights      US
# ..   ...          ...     ...

select(cran, r_arch:country)

# Source: local data frame [225,468 x 5]

   # r_arch      r_os      package version country
# 1  x86_64   mingw32    htmltools   0.2.4      US
# 2  x86_64   mingw32      tseries 0.10-32      US
# 3  x86_64 linux-gnu        party  1.0-15      US
# 4  x86_64 linux-gnu        Hmisc  3.14-4      US
# 5  x86_64 linux-gnu       digest   0.6.4      CA
# 6  x86_64 linux-gnu randomForest   4.6-7      US
# 7  x86_64 linux-gnu         plyr   1.8.1      US
# 8  x86_64 linux-gnu      whisker   0.3-2      US
# 9      NA        NA         Rcpp  0.10.4      CN
# 10 x86_64 linux-gnu     hflights     0.1      US
# ..    ...       ...          ...     ...     ...

select(cran, country:r_arch) #reverse order

# Source: local data frame [225,468 x 5]

   # country version      package      r_os r_arch
# 1       US   0.2.4    htmltools   mingw32 x86_64
# 2       US 0.10-32      tseries   mingw32 x86_64
# 3       US  1.0-15        party linux-gnu x86_64
# 4       US  3.14-4        Hmisc linux-gnu x86_64
# 5       CA   0.6.4       digest linux-gnu x86_64
# 6       US   4.6-7 randomForest linux-gnu x86_64
# 7       US   1.8.1         plyr linux-gnu x86_64
# 8       US   0.3-2      whisker linux-gnu x86_64
# 9       CN  0.10.4         Rcpp        NA     NA
# 10      US     0.1     hflights linux-gnu x86_64
# ..     ...     ...          ...       ...    ...


select(cran, -time) #all but 'time' column

select(cran,-(X:size)) #omit all columns  'X' through 'size'

# Source: local data frame [225,468 x 7]

   # r_version r_arch      r_os      package version country ip_id
# 1      3.1.0 x86_64   mingw32    htmltools   0.2.4      US     1
# 2      3.1.0 x86_64   mingw32      tseries 0.10-32      US     2
# 3      3.1.0 x86_64 linux-gnu        party  1.0-15      US     3
# 4      3.1.0 x86_64 linux-gnu        Hmisc  3.14-4      US     3
# 5      3.0.2 x86_64 linux-gnu       digest   0.6.4      CA     4
# 6      3.1.0 x86_64 linux-gnu randomForest   4.6-7      US     3
# 7      3.1.0 x86_64 linux-gnu         plyr   1.8.1      US     3
# 8      3.0.2 x86_64 linux-gnu      whisker   0.3-2      US     5
# 9         NA     NA        NA         Rcpp  0.10.4      CN     6
# 10     3.0.2 x86_64 linux-gnu     hflights     0.1      US     7
# ..       ...    ...       ...          ...     ...     ...   ...

###################
#filter - take rows
###################
filter(cran, package == "swirl")
# Source: local data frame [820 x 11]

      # X       date     time   size r_version r_arch         r_os package
# 1    27 2014-07-08 00:17:16 105350     3.0.2 x86_64      mingw32   swirl
# 2   156 2014-07-08 00:22:53  41261     3.1.0 x86_64    linux-gnu   swirl
# 3   358 2014-07-08 00:13:42 105335    2.15.2 x86_64      mingw32   swirl
# 4   593 2014-07-08 00:59:45 105465     3.1.0 x86_64 darwin13.1.0   swirl
# 5   831 2014-07-08 00:55:27 105335     3.0.3 x86_64      mingw32   swirl
# 6   997 2014-07-08 00:33:06  41261     3.1.0 x86_64      mingw32   swirl
# 7  1023 2014-07-08 00:35:36 106393     3.1.0 x86_64      mingw32   swirl
# 8  1144 2014-07-08 00:00:39 106534     3.0.2 x86_64    linux-gnu   swirl
# 9  1402 2014-07-08 00:41:41  41261     3.1.0   i386      mingw32   swirl
# 10 1424 2014-07-08 00:44:49 106393     3.1.0 x86_64    linux-gnu   swirl
# ..  ...        ...      ...    ...       ...    ...          ...     ...
# Variables not shown: version (chr), country (chr), ip_id (int)


filter(cran, r_version == "3.1.1", country == "US") #comma means logical AND

filter(cran, r_version <= "3.0.2", country == "IN")

filter(cran, country == "US" | country == "IN")

filter(cran, size > 100500, r_os == "linux-gnu")

is.na(c(3,5,NA,10))
#[1] FALSE FALSE  TRUE FALSE

!is.na(c(3,5,NA,10))
#[1]  TRUE  TRUE FALSE  TRUE

filter(cran, !is.na(r_version)) #all rows where r version not NA

# Source: local data frame [207,205 x 11]

    # X       date     time    size r_version r_arch      r_os      package
# 1   1 2014-07-08 00:54:41   80589     3.1.0 x86_64   mingw32    htmltools
# 2   2 2014-07-08 00:59:53  321767     3.1.0 x86_64   mingw32      tseries
# 3   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu        party
# 4   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu        Hmisc
# 5   5 2014-07-08 00:46:50   79825     3.0.2 x86_64 linux-gnu       digest
# 6   6 2014-07-08 00:48:04   77681     3.1.0 x86_64 linux-gnu randomForest
# 7   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu         plyr
# 8   8 2014-07-08 00:47:30   28216     3.0.2 x86_64 linux-gnu      whisker
# 9  10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu     hflights
# 10 11 2014-07-08 00:15:25  526858     3.0.2 x86_64 linux-gnu         LPCM
# .. ..        ...      ...     ...       ...    ...       ...          ...
# Variables not shown: version (chr), country (chr), ip_id (int)


####################
#arrange - sort rows
####################

cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id)
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id) #sort by two vars
arrange(cran2, country, desc(r_version), ip_id)


#######################################
#mutate - create new vars from old ones
#######################################

cran3 <- select(cran, ip_id, package, size)

mutate(cran3, size_mb = size/ 2 ^20)
# Source: local data frame [225,468 x 4]

   # ip_id      package    size     size_mb
# 1      1    htmltools   80589 0.076855659
# 2      2      tseries  321767 0.306860924
# 3      3        party  748063 0.713408470
# 4      3        Hmisc  606104 0.578025818
# 5      4       digest   79825 0.076127052
# 6      3 randomForest   77681 0.074082375
# 7      3         plyr  393754 0.375513077
# 8      5      whisker   28216 0.026908875
# 9      6         Rcpp    5928 0.005653381
# 10     7     hflights 2206029 2.103833199


mutate(cran3, size_mb = size/ 2 ^20, size_gb = size_mb / 2 ^ 10)
# Source: local data frame [225,468 x 5]

   # ip_id      package    size     size_mb      size_gb
# 1      1    htmltools   80589 0.076855659 7.505435e-05
# 2      2      tseries  321767 0.306860924 2.996689e-04
# 3      3        party  748063 0.713408470 6.966880e-04
# 4      3        Hmisc  606104 0.578025818 5.644783e-04
# 5      4       digest   79825 0.076127052 7.434282e-05
# 6      3 randomForest   77681 0.074082375 7.234607e-05
# 7      3         plyr  393754 0.375513077 3.667120e-04
# 8      5      whisker   28216 0.026908875 2.627820e-05
# 9      6         Rcpp    5928 0.005653381 5.520880e-06
# 10     7     hflights 2206029 2.103833199 2.054525e-03

mutate(cran3, correct_size = size + 1000)

############################################
#summarize - collapse tbl down to single row
############################################

summarize(cran, avg_bytes = mean(size))


############################################
############################################
#Lesson 2 - Grouping and Chaining With dplyr
############################################
############################################


library(dplyr)
cran <- tbl_df(mydf)
rm("mydf") #get rid of original df, no longer needed
cran #nice printing with tbl_df versus standard df

# Source: local data frame [225,468 x 11]

    # X       date     time    size r_version r_arch      r_os      package
# 1   1 2014-07-08 00:54:41   80589     3.1.0 x86_64   mingw32    htmltools
# 2   2 2014-07-08 00:59:53  321767     3.1.0 x86_64   mingw32      tseries
# 3   3 2014-07-08 00:47:13  748063     3.1.0 x86_64 linux-gnu        party
# 4   4 2014-07-08 00:48:05  606104     3.1.0 x86_64 linux-gnu        Hmisc
# 5   5 2014-07-08 00:46:50   79825     3.0.2 x86_64 linux-gnu       digest
# 6   6 2014-07-08 00:48:04   77681     3.1.0 x86_64 linux-gnu randomForest
# 7   7 2014-07-08 00:48:35  393754     3.1.0 x86_64 linux-gnu         plyr
# 8   8 2014-07-08 00:47:30   28216     3.0.2 x86_64 linux-gnu      whisker
# 9   9 2014-07-08 00:54:58    5928        NA     NA        NA         Rcpp
# 10 10 2014-07-08 00:15:35 2206029     3.0.2 x86_64 linux-gnu     hflights
# .. ..        ...      ...     ...       ...    ...       ...          ...
# Variables not shown: version (chr), country (chr), ip_id (int)


#http://127.0.0.1:26437/library/dplyr/html/group_by.html

by_package <- group_by(cran, package)
#summarize(cran, avg_bytes = mean(size))
summarize(by_package, mean(size))

# Source: local data frame [6,023 x 2]

       # package mean(size)
# 1           A3   62194.96
# 2  ABCExtremes   22904.33
# 3     ABCoptim   17807.25
# 4        ABCp2   30473.33
# 5       ACCLMA   33375.53
# 6          ACD   99055.29
# 7         ACNE   96099.75
# 8        ACTCD  134746.27
# 9    ADGofTest   12262.91
# 10        ADM3 1077203.47
# ..         ...        ...


# Compute four values, in the following order, from
# the grouped data:
#
# 1. count = n()
# 2. unique = n_distinct(ip_id)
# 3. countries = n_distinct(country)
# 4. avg_bytes = mean(size)
#
# A few thing to be careful of:
#
# 1. Separate arguments by commas
# 2. Make sure you have a closing parenthesis
# 3. Check your spelling!
# 4. Store the result in pack_sum (for 'package summary')
#
# You should also take a look at ?n and ?n_distinct, so
# that you really understand what is going on.

pack_sum <- summarize(by_package,
                      count =  n(),
                      unique =  n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

# Source: local data frame [6,023 x 5]

       # package count unique countries  avg_bytes
# 1           A3    25     24        10   62194.96
# 2  ABCExtremes    18     17         9   22904.33
# 3     ABCoptim    16     15         9   17807.25
# 4        ABCp2    18     17        10   30473.33
# 5       ACCLMA    15     14         9   33375.53
# 6          ACD    17     16        10   99055.29
# 7         ACNE    16     15        10   96099.75
# 8        ACTCD    15     14         9  134746.27
# 9    ADGofTest    47     44        20   12262.91
# 10        ADM3    17     16        10 1077203.47
# ..         ...   ...    ...       ...        ...

quantile(pack_sum$count, probs = 0.99)
# 99% 
# 679.56 

top_counts <- filter(pack_sum, count > 679)
Source: local data frame [61 x 5]

        # package count unique countries   avg_bytes
# 1           DBI  2599    492        48  206933.250
# 2       Formula   852    777        65  155742.002
# 3         Hmisc   954    812        69 1367675.911
# 4          LPCM  2335     17        10  526814.226
# 5          MASS   834    698        66  981152.179
# 6        Matrix   932    801        66 3220134.165
# 7  RColorBrewer  1890   1584        79   22763.995
# 8         RCurl  1504   1207        73 1903505.324
# 9         RJDBC   809    107        28   18715.441
# 10      RJSONIO   751    585        60 1208103.992
# 11       RMySQL   862     98        21  212832.918
# 12         Rcpp  3195   2044        84 2512100.355
# 13      SparseM  1167    454        60  674890.722
# 14          VIF   697     37        12 2344226.571
# 15          XML  1022    770        62 2927022.407
# 16       bitops  1549   1408        76   28715.046
# 17      caTools   812    699        64  176589.018
# 18          car  1008    837        64 1229122.307
# 19   colorspace  1683   1433        80  357411.197
# 20   data.table   680    564        59 1252721.215
# 21     devtools   769    560        55  212932.640
# 22    dichromat  1486   1257        74  134731.938
# 23       digest  2210   1894        83  120549.294
# 24       doSNOW   740     75        24    8363.755
# 25     evaluate  1095    998        73   35139.161
# 26      foreach  1984    485        53  358069.782
# 27      formatR   815    709        65   43311.099
# 28      ggplot2  4602   1680        81 2427716.054
# 29       gplots   708    645        65  519971.459
# 30       gtable  1466   1255        75   55137.990
# 31       gtools   875    793        62  109778.034
# 32        highr   807    709        64   27969.524
# 33    htmltools   762    656        55   65717.295
# 34         httr  1195   1015        68  293879.626
# 35    iterators  1887    462        53  294757.526
# 36        knitr  1037    885        70  946708.266
# 37     labeling  1502   1270        75   34739.487
# 38 latticeExtra   887    791        69 1909937.068
# 39         lme4   938    756        68 3921084.377
# 40     markdown   939    809        66  138671.633
# 41         mgcv  1122   1006        72 1674032.285
# 42         mime   886    780        65   15268.103
# 43      munsell  1514   1276        75  119432.542
# 44      mvtnorm   841    729        64  203047.132
# 45       nloptr   756    682        63  754357.567
# 46         plyr  2908   1754        81  799122.790
# 47        proto  1500   1281        76  469796.779
# 48     quantreg  1098    388        54 1733616.958
# 49        rJava  2773    963        70  633522.348
# 50     reshape2  2032   1652        76  330128.263
# 51          rgl   786    655        70 2543589.210
# 52       scales  1726   1408        77  126819.331
# 53        shiny   713    455        50 1212965.833
# 54         snow   809    134        30   28989.546
# 55      stringr  2267   1948        82   65277.166
# 56        swirl   820    698        66   95868.696
# 57     testthat   818    755        64  188230.345
# 58         xlsx   798    578        59  380129.548
# 59       xtable   751    611        54  376072.182
# 60         yaml  1062    982        72  161006.309
# 61          zoo  1245   1073        63  857691.878

head(top_counts, 20)
arrange(top_counts, desc(count))

# Source: local data frame [61 x 5]

        # package count unique countries   avg_bytes
# 1       ggplot2  4602   1680        81 2427716.054
# 2          Rcpp  3195   2044        84 2512100.355
# 3          plyr  2908   1754        81  799122.790
# 4         rJava  2773    963        70  633522.348
# 5           DBI  2599    492        48  206933.250
# 6          LPCM  2335     17        10  526814.226
# 7       stringr  2267   1948        82   65277.166
# 8        digest  2210   1894        83  120549.294
# 9      reshape2  2032   1652        76  330128.263
# 10      foreach  1984    485        53  358069.782
# 11 RColorBrewer  1890   1584        79   22763.995
# 12    iterators  1887    462        53  294757.526
# 13       scales  1726   1408        77  126819.331
# 14   colorspace  1683   1433        80  357411.197
# 15       bitops  1549   1408        76   28715.046
# 16      munsell  1514   1276        75  119432.542
# 17        RCurl  1504   1207        73 1903505.324
# 18     labeling  1502   1270        75   34739.487
# 19        proto  1500   1281        76  469796.779
# 20    dichromat  1486   1257        74  134731.938
# 21       gtable  1466   1255        75   55137.990
# 22          zoo  1245   1073        63  857691.878
# 23         httr  1195   1015        68  293879.626
# 24      SparseM  1167    454        60  674890.722
# 25         mgcv  1122   1006        72 1674032.285
# 26     quantreg  1098    388        54 1733616.958
# 27     evaluate  1095    998        73   35139.161
# 28         yaml  1062    982        72  161006.309
# 29        knitr  1037    885        70  946708.266
# 30          XML  1022    770        62 2927022.407
# 31          car  1008    837        64 1229122.307
# 32        Hmisc   954    812        69 1367675.911
# 33     markdown   939    809        66  138671.633
# 34         lme4   938    756        68 3921084.377
# 35       Matrix   932    801        66 3220134.165
# 36 latticeExtra   887    791        69 1909937.068
# 37         mime   886    780        65   15268.103
# 38       gtools   875    793        62  109778.034
# 39       RMySQL   862     98        21  212832.918
# 40      Formula   852    777        65  155742.002
# 41      mvtnorm   841    729        64  203047.132
# 42         MASS   834    698        66  981152.179
# 43        swirl   820    698        66   95868.696
# 44     testthat   818    755        64  188230.345
# 45      formatR   815    709        65   43311.099
# 46      caTools   812    699        64  176589.018
# 47        RJDBC   809    107        28   18715.441
# 48         snow   809    134        30   28989.546
# 49        highr   807    709        64   27969.524
# 50         xlsx   798    578        59  380129.548
# 51          rgl   786    655        70 2543589.210
# 52     devtools   769    560        55  212932.640
# 53    htmltools   762    656        55   65717.295
# 54       nloptr   756    682        63  754357.567
# 55      RJSONIO   751    585        60 1208103.992
# 56       xtable   751    611        54  376072.182
# 57       doSNOW   740     75        24    8363.755
# 58        shiny   713    455        50 1212965.833
# 59       gplots   708    645        65  519971.459
# 60          VIF   697     37        12 2344226.571
# 61   data.table   680    564        59 1252721.215


quantile(pack_sum$unique, probs = 0.99)
# 99% 
# 465

top_unique <- filter(pack_sum, unique > 465)

# Source: local data frame [60 x 5]

        # package count unique countries  avg_bytes
# 1           DBI  2599    492        48  206933.25
# 2       Formula   852    777        65  155742.00
# 3         Hmisc   954    812        69 1367675.91
# 4          MASS   834    698        66  981152.18
# 5        Matrix   932    801        66 3220134.17
# 6  RColorBrewer  1890   1584        79   22763.99
# 7         RCurl  1504   1207        73 1903505.32
# 8       RJSONIO   751    585        60 1208103.99
# 9          Rcpp  3195   2044        84 2512100.35
# 10    RcppEigen   546    474        52 2032426.11
# 11          XML  1022    770        62 2927022.41
# 12       bitops  1549   1408        76   28715.05
# 13      caTools   812    699        64  176589.02
# 14          car  1008    837        64 1229122.31
# 15   colorspace  1683   1433        80  357411.20
# 16   data.table   680    564        59 1252721.21
# 17     devtools   769    560        55  212932.64
# 18    dichromat  1486   1257        74  134731.94
# 19       digest  2210   1894        83  120549.29
# 20        e1071   562    482        61  743153.75
# 21     evaluate  1095    998        73   35139.16
# 22      foreach  1984    485        53  358069.78
# 23      formatR   815    709        65   43311.10
# 24        gdata   673    619        57  800502.47
# 25      ggplot2  4602   1680        81 2427716.05
# 26       gplots   708    645        65  519971.46
# 27       gtable  1466   1255        75   55137.99
# 28       gtools   875    793        62  109778.03
# 29        highr   807    709        64   27969.52
# 30    htmltools   762    656        55   65717.30
# 31         httr  1195   1015        68  293879.63
# 32        knitr  1037    885        70  946708.27
# 33     labeling  1502   1270        75   34739.49
# 34      lattice   627    523        56  642181.03
# 35 latticeExtra   887    791        69 1909937.07
# 36         lme4   938    756        68 3921084.38
# 37     markdown   939    809        66  138671.63
# 38      memoise   678    600        59   14023.51
# 39         mgcv  1122   1006        72 1674032.29
# 40         mime   886    780        65   15268.10
# 41      munsell  1514   1276        75  119432.54
# 42      mvtnorm   841    729        64  203047.13
# 43       nloptr   756    682        63  754357.57
# 44         plyr  2908   1754        81  799122.79
# 45        proto  1500   1281        76  469796.78
# 46        rJava  2773    963        70  633522.35
# 47      reshape   611    522        52  111337.99
# 48     reshape2  2032   1652        76  330128.26
# 49          rgl   786    655        70 2543589.21
# 50     sandwich   597    507        56  491268.38
# 51       scales  1726   1408        77  126819.33
# 52           sp   559    470        54 1410246.55
# 53      stringr  2267   1948        82   65277.17
# 54        swirl   820    698        66   95868.70
# 55     testthat   818    755        64  188230.34
# 56         xlsx   798    578        59  380129.55
# 57     xlsxjars   665    527        58 9214537.15
# 58       xtable   751    611        54  376072.18
# 59         yaml  1062    982        72  161006.31
# 60          zoo  1245   1073        63  857691.88


arrange(top_unique, desc(unique))

# Source: local data frame [60 x 5]

        # package count unique countries  avg_bytes
# 1          Rcpp  3195   2044        84 2512100.35
# 2       stringr  2267   1948        82   65277.17
# 3        digest  2210   1894        83  120549.29
# 4          plyr  2908   1754        81  799122.79
# 5       ggplot2  4602   1680        81 2427716.05
# 6      reshape2  2032   1652        76  330128.26
# 7  RColorBrewer  1890   1584        79   22763.99
# 8    colorspace  1683   1433        80  357411.20
# 9        bitops  1549   1408        76   28715.05
# 10       scales  1726   1408        77  126819.33
# 11        proto  1500   1281        76  469796.78
# 12      munsell  1514   1276        75  119432.54
# 13     labeling  1502   1270        75   34739.49
# 14    dichromat  1486   1257        74  134731.94
# 15       gtable  1466   1255        75   55137.99
# 16        RCurl  1504   1207        73 1903505.32
# 17          zoo  1245   1073        63  857691.88
# 18         httr  1195   1015        68  293879.63
# 19         mgcv  1122   1006        72 1674032.29
# 20     evaluate  1095    998        73   35139.16
# 21         yaml  1062    982        72  161006.31
# 22        rJava  2773    963        70  633522.35
# 23        knitr  1037    885        70  946708.27
# 24          car  1008    837        64 1229122.31
# 25        Hmisc   954    812        69 1367675.91
# 26     markdown   939    809        66  138671.63
# 27       Matrix   932    801        66 3220134.17
# 28       gtools   875    793        62  109778.03
# 29 latticeExtra   887    791        69 1909937.07
# 30         mime   886    780        65   15268.10
# 31      Formula   852    777        65  155742.00
# 32          XML  1022    770        62 2927022.41
# 33         lme4   938    756        68 3921084.38
# 34     testthat   818    755        64  188230.34
# 35      mvtnorm   841    729        64  203047.13
# 36      formatR   815    709        65   43311.10
# 37        highr   807    709        64   27969.52
# 38      caTools   812    699        64  176589.02
# 39         MASS   834    698        66  981152.18
# 40        swirl   820    698        66   95868.70
# 41       nloptr   756    682        63  754357.57
# 42    htmltools   762    656        55   65717.30
# 43          rgl   786    655        70 2543589.21
# 44       gplots   708    645        65  519971.46
# 45        gdata   673    619        57  800502.47
# 46       xtable   751    611        54  376072.18
# 47      memoise   678    600        59   14023.51
# 48      RJSONIO   751    585        60 1208103.99
# 49         xlsx   798    578        59  380129.55
# 50   data.table   680    564        59 1252721.21
# 51     devtools   769    560        55  212932.64
# 52     xlsxjars   665    527        58 9214537.15
# 53      lattice   627    523        56  642181.03
# 54      reshape   611    522        52  111337.99
# 55     sandwich   597    507        56  491268.38
# 56          DBI  2599    492        48  206933.25
# 57      foreach  1984    485        53  358069.78
# 58        e1071   562    482        61  743153.75
# 59    RcppEigen   546    474        52 2032426.11
# 60           sp   559    470        54 1410246.55


# Don't change any of the code below. Just type submit()
# when you think you understand it.

# We've already done this part, but we're repeating it
# here for clarity.

by_package <- group_by(cran, package)
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))

# Here's the new bit, but using the same approach we've
# been using this whole time.

top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)

# Print the results to the console.
print(result1)

# Source: local data frame [46 x 5]

         # package count unique countries  avg_bytes
# 1           Rcpp  3195   2044        84 2512100.35
# 2         digest  2210   1894        83  120549.29
# 3        stringr  2267   1948        82   65277.17
# 4           plyr  2908   1754        81  799122.79
# 5        ggplot2  4602   1680        81 2427716.05
# 6     colorspace  1683   1433        80  357411.20
# 7   RColorBrewer  1890   1584        79   22763.99
# 8         scales  1726   1408        77  126819.33
# 9         bitops  1549   1408        76   28715.05
# 10      reshape2  2032   1652        76  330128.26
# 11         proto  1500   1281        76  469796.78
# 12      labeling  1502   1270        75   34739.49
# 13        gtable  1466   1255        75   55137.99
# 14       munsell  1514   1276        75  119432.54
# 15     dichromat  1486   1257        74  134731.94
# 16      evaluate  1095    998        73   35139.16
# 17         RCurl  1504   1207        73 1903505.32
# 18          yaml  1062    982        72  161006.31
# 19          mgcv  1122   1006        72 1674032.29
# 20         rJava  2773    963        70  633522.35
# 21         knitr  1037    885        70  946708.27
# 22           rgl   786    655        70 2543589.21
# 23         Hmisc   954    812        69 1367675.91
# 24  latticeExtra   887    791        69 1909937.07
# 25          httr  1195   1015        68  293879.63
# 26          lme4   938    756        68 3921084.38
# 27         swirl   820    698        66   95868.70
# 28      markdown   939    809        66  138671.63
# 29          MASS   834    698        66  981152.18
# 30        Matrix   932    801        66 3220134.17
# 31          mime   886    780        65   15268.10
# 32       formatR   815    709        65   43311.10
# 33       Formula   852    777        65  155742.00
# 34        gplots   708    645        65  519971.46
# 35         highr   807    709        64   27969.52
# 36       caTools   812    699        64  176589.02
# 37      testthat   818    755        64  188230.34
# 38       mvtnorm   841    729        64  203047.13
# 39           car  1008    837        64 1229122.31
# 40        nloptr   756    682        63  754357.57
# 41           zoo  1245   1073        63  857691.88
# 42       aplpack   416    382        63 3132834.19
# 43        gtools   875    793        62  109778.03
# 44           XML  1022    770        62 2927022.41
# 45         e1071   562    482        61  743153.75
# 46 RcppArmadillo   505    444        61 1340652.31


# Don't change any of the code below. Just type submit()
# when you think you understand it. If you find it
# confusing, you're absolutely right!

result2 <-
  arrange(
    filter(
      summarize(
        group_by(cran,
                 package
        ),
        count = n(),
        unique = n_distinct(ip_id),
        countries = n_distinct(country),
        avg_bytes = mean(size)
      ),
      countries > 60
    ),
    desc(countries),
    avg_bytes
  )

print(result2)


# Read the code below, but don't change anything. As
# you read it, you can pronounce the %>% operator as
# the word 'then'.
#
# Type submit() when you think you understand
# everything here.

result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)


# select() the following columns from cran. Keep in mind
# that when you're using the chaining operator, you don't
# need to specify the name of the data tbl in your call to
# select().
#
# 1. ip_id
# 2. country
# 3. package
# 4. size
#
# The call to print() at the end of the chain is optional,
# but necessary if you want your results printed to the
# console. Note that since there are no additional arguments
# to print(), you can just leave of the parentheses after
# the function name. This is a convenient feature of the %>%
# operator.

cran %>%
  select(ip_id, country, package, size) %>%
	print

# Use mutate() to add a column called size_mb that contains
# the size of each download in megabytes (i.e. size / 2^20).
#
# If you want your results printed to the console, add
# print to the end of your chain.


cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20)
  print
  
  
# Source: local data frame [225,468 x 5]

   # ip_id country      package    size     size_mb
# 1      1      US    htmltools   80589 0.076855659
# 2      2      US      tseries  321767 0.306860924
# 3      3      US        party  748063 0.713408470
# 4      3      US        Hmisc  606104 0.578025818
# 5      4      CA       digest   79825 0.076127052
# 6      3      US randomForest   77681 0.074082375
# 7      3      US         plyr  393754 0.375513077
# 8      5      US      whisker   28216 0.026908875
# 9      6      CN         Rcpp    5928 0.005653381
# 10     7      US     hflights 2206029 2.103833199

# Use filter() to select all rows for which size_mb is
# less than or equal to (<=) 0.5.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  print

# Source: local data frame [142,021 x 5]

   # ip_id country      package   size     size_mb
# 1      1      US    htmltools  80589 0.076855659
# 2      2      US      tseries 321767 0.306860924
# 3      4      CA       digest  79825 0.076127052
# 4      3      US randomForest  77681 0.074082375
# 5      3      US         plyr 393754 0.375513077
# 6      5      US      whisker  28216 0.026908875
# 7      6      CN         Rcpp   5928 0.005653381
# 8     13      DE        ipred 186685 0.178036690
# 9     14      US       mnormt  36204 0.034526825
# 10    16      US    iterators 289972 0.276538849

# arrange() the result by size_mb, in descending order.
#
# If you want your results printed to the console, add
# print to the end of your chain.

cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb)) %>%
  print

# Source: local data frame [142,021 x 5]

   # ip_id country               package   size   size_mb
# 1  11034      DE                  phia 524232 0.4999466
# 2   9643      US                   tis 524152 0.4998703
# 3   1542      IN               RcppSMC 524060 0.4997826
# 4  12354      US                 lessR 523916 0.4996452
# 5  12072      US            colorspace 523880 0.4996109
# 6   2514      KR              depmixS4 523863 0.4995947
# 7   1111      US              depmixS4 523858 0.4995899
# 8   8865      CR              depmixS4 523858 0.4995899
# 9   5908      CN RcmdrPlugin.KMggplot2 523852 0.4995842
# 10 12354      US RcmdrPlugin.KMggplot2 523852 0.4995842

  
###################################
###################################
#Lesson 3 - Tidying Data with tidyr
###################################
###################################
install.packages("tidyr")
library(dplyr)
library(tidyr)

#Tidy data is formatted in a standard way that facilitates exploration and
# | analysis and works seemlessly with other tidy data tools. Specifically, tidy
# | data satisfies three conditions:
# | 
# | 1) Each variable forms a column
# | 
# | 2) Each observation forms a row
# | 
# | 3) Each type of observational unit forms a table

# Any dataset that doesn't satisfy these conditions is considered 'messy' data.
# | Therefore, all of the following are characteristics of messy data, EXCEPT...

# 1: Column headers are values, not variable names
# 2: Variables are stored in both rows and columns
# 3: A single observational unit is stored in multiple tables
# 4: Multiple types of observational units are stored in the same table
# 5: Multiple variables are stored in one column
# 6: Every column contains a different variable <<< correct answer

#messy data with column headers that are values not variable names
students 

  # grade male female
# 1     A    1      5
# 2     B    5      0
# 3     C    5      2
# 4     D    5      5
# 5     E    7      4

 # To tidy the students data, we need to have one column for each of these three
# | variables. We'll use the gather() function from tidyr to accomplish this.
# | Pull up the documentation for this function with ?gather.

?gather

stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)

#do either
gather(stocks, stock, price, -time)
#or... 
stocks %>% gather(stock, price, -time)

         # time stock       price
# 1  2009-01-01     X -1.11472517
# 2  2009-01-02     X  0.55749980
# 3  2009-01-03     X -0.16610036
# 4  2009-01-04     X  1.04284238
# 5  2009-01-05     X  0.89186048
# 6  2009-01-06     X -0.71713985
# 7  2009-01-07     X -0.01046453
# 8  2009-01-08     X  0.04589559
# 9  2009-01-09     X  0.10544507
# 10 2009-01-10     X  0.68357663
# 11 2009-01-01     Y  0.39471033
# 12 2009-01-02     Y  0.33488321
# 13 2009-01-03     Y  2.37462037
# 14 2009-01-04     Y -0.27649026
# 15 2009-01-05     Y -1.96376364
# 16 2009-01-06     Y  2.95271389
# 17 2009-01-07     Y -0.42092918
# 18 2009-01-08     Y  0.73448928
# 19 2009-01-09     Y -0.52305328
# 20 2009-01-10     Y  0.78073900
# 21 2009-01-01     Z  5.43671907
# 22 2009-01-02     Z -2.38357446
# 23 2009-01-03     Z -0.67681292
# 24 2009-01-04     Z  4.07875676
# 25 2009-01-05     Z  4.80984930
# 26 2009-01-06     Z  0.29549848
# 27 2009-01-07     Z -4.26060659
# 28 2009-01-08     Z -1.66203434
# 29 2009-01-09     Z  4.31457643
# 30 2009-01-10     Z  4.70969401


gather(students, sex, count, -grade)
   # grade    sex count
# 1      A   male     1
# 2      B   male     5
# 3      C   male     5
# 4      D   male     5
# 5      E   male     7
# 6      A female     5
# 7      B female     0
# 8      C female     2
# 9      D female     5
# 10     E female     4


# The second messy data case we'll look at is when multiple variables are
# stored in one column. Type students2 to see an example of this.

students2

  # grade male_1 female_1 male_2 female_2
# 1     A      3        4      3        4
# 2     B      6        4      3        5
# 3     C      7        4      3        8
# 4     D      4        0      8        1
# 5     E      1        1      2        7

# Let's start by using gather() to stack the columns of students2, like we just
# did with students. This time, name the 'key' column sex_class and the 'value'
# column count. Save the result to a new variable called res. Consult ?gather
# again if you need help.

res <- gather(students2, sex_class, count, -grade)
 
   # grade sex_class count
# 1      A    male_1     3
# 2      B    male_1     6
# 3      C    male_1     7
# 4      D    male_1     4
# 5      E    male_1     1
# 6      A  female_1     4
# 7      B  female_1     4
# 8      C  female_1     4
# 9      D  female_1     0
# 10     E  female_1     1
# 11     A    male_2     3
# 12     B    male_2     3
# 13     C    male_2     3
# 14     D    male_2     8
# 15     E    male_2     2
# 16     A  female_2     4
# 17     B  female_2     5
# 18     C  female_2     8
# 19     D  female_2     1
# 20     E  female_2     7


#example of separate from online docs:
mydf <- data.frame(x = c("a.b", "a.d", "b.c"))
mydf %>% separate(x, c("A", "B"))


separate(res, sex_class, c("sex", class))

   # grade    sex class count
# 1      A   male     1     3
# 2      B   male     1     6
# 3      C   male     1     7
# 4      D   male     1     4
# 5      E   male     1     1
# 6      A female     1     4
# 7      B female     1     4
# 8      C female     1     4
# 9      D female     1     0
# 10     E female     1     1
# 11     A   male     2     3
# 12     B   male     2     3
# 13     C   male     2     3
# 14     D   male     2     8
# 15     E   male     2     2
# 16     A female     2     4
# 17     B female     2     5
# 18     C female     2     8
# 19     D female     2     1
# 20     E female     2     7

#using chaining
# Repeat your calls to gather() and separate(), but this time
# use the %>% operator to chain the commands together without
# storing an intermediate result.
#
# If this is your first time seeing the %>% operator, check
# out ?chain, which will bring up the relevant documentation.
# You can also look at the Examples section at the bottom
# of ?gather and ?separate.
#
# The main idea is that the result to the left of %>%
# takes the place of the first argument of the function to
# the right. Therefore, you OMIT THE FIRST ARGUMENT to each
# function.
#
students2 %>%
  gather(sex_class , count, -grade) %>%
  separate(sex_class , c("sex", "class")) %>%
  print

# A third symptom of messy data is when variables are stored in both rows and
# columns. students3 provides an example of this. Print students3 to the
# console.

students3

    # name    test class1 class2 class3 class4 class5
# 1  Sally midterm      A   <NA>      B   <NA>   <NA>
# 2  Sally   final      C   <NA>      C   <NA>   <NA>
# 3   Jeff midterm   <NA>      D   <NA>      A   <NA>
# 4   Jeff   final   <NA>      E   <NA>      C   <NA>
# 5  Roger midterm   <NA>      C   <NA>   <NA>      B
# 6  Roger   final   <NA>      A   <NA>   <NA>      A
# 7  Karen midterm   <NA>   <NA>      C      A   <NA>
# 8  Karen   final   <NA>   <NA>      C      A   <NA>
# 9  Brian midterm      B   <NA>   <NA>   <NA>      A
# 10 Brian   final      B   <NA>   <NA>   <NA>      C
  
# The first variable, name, is already a column and should remain as it is. The
# | headers of the last five columns, class1 through class5, are all different
# | values of what should be a class variable. The values in the test column,
# | midterm and final, should each be its own variable containing the respective
# | grades for each student.



#Step 1:
# Call gather() to gather the columns class1 through
# through class5 into a new variable called class.
# The 'key' should be class, and the 'value'
# should be grade.
#
# tidyr makes it easy to reference multiple adjacent
# columns with class1:class5, just like with sequences
# of numbers.
#
# Since each student is only enrolled in two of
# the five possible classes, there are lots of missing
# values (i.e. NAs). Use the argument na.rm = TRUE
# to omit these values from the final result.
#
# Remember that when you're using the %>% operator,
# the value to the left of it gets inserted as the
# first argument to the function on the right.
#
# Consult ?gather and/or ?chain if you get stuck.
#
students3 %>%
  gather(class , grade , class1:class5 , -(name:test),  na.rm = TRUE ) %>%
  print

# The next step will require the use of spread(). Pull up the documentation for
# | spread() now.

?spread

stocks <- data.frame(
    time = as.Date('2009-01-01') + 0:9,
    X = rnorm(10, 0, 1),
    Y = rnorm(10, 0, 2),
    Z = rnorm(10, 0, 4)
)

         # time          X         Y          Z
# 1  2009-01-01 -0.1083095  3.910450 -7.2288668
# 2  2009-01-02  0.1131623  1.043821  0.2073273
# 3  2009-01-03  1.1011019 -2.214794 -3.3405555
# 4  2009-01-04  0.6682214  4.395654  5.1230922
# 5  2009-01-05 -0.9439180 -1.139381  1.0345520
# 6  2009-01-06  1.1424793  4.130842  4.4570703
# 7  2009-01-07 -0.3595520  1.708617 -2.6698576
# 8  2009-01-08  1.0357524  1.423007 -2.7228473
# 9  2009-01-09 -0.8674234  2.383576 -0.9256220
# 10 2009-01-10 -0.6661167 -1.067021  4.1033606


stocksm <- stocks %>% gather(stock, price, -time)

         # time stock      price
# 1  2009-01-01     X -0.1083095
# 2  2009-01-02     X  0.1131623
# 3  2009-01-03     X  1.1011019
# 4  2009-01-04     X  0.6682214
# 5  2009-01-05     X -0.9439180
# 6  2009-01-06     X  1.1424793
# 7  2009-01-07     X -0.3595520
# 8  2009-01-08     X  1.0357524
# 9  2009-01-09     X -0.8674234
# 10 2009-01-10     X -0.6661167
# 11 2009-01-01     Y  3.9104498
# 12 2009-01-02     Y  1.0438207
# 13 2009-01-03     Y -2.2147939
# 14 2009-01-04     Y  4.3956544
# 15 2009-01-05     Y -1.1393811
# 16 2009-01-06     Y  4.1308424
# 17 2009-01-07     Y  1.7086170
# 18 2009-01-08     Y  1.4230068
# 19 2009-01-09     Y  2.3835761
# 20 2009-01-10     Y -1.0670207
# 21 2009-01-01     Z -7.2288668
# 22 2009-01-02     Z  0.2073273
# 23 2009-01-03     Z -3.3405555
# 24 2009-01-04     Z  5.1230922
# 25 2009-01-05     Z  1.0345520
# 26 2009-01-06     Z  4.4570703
# 27 2009-01-07     Z -2.6698576
# 28 2009-01-08     Z -2.7228473
# 29 2009-01-09     Z -0.9256220
# 30 2009-01-10     Z  4.1033606

#undoes the work of gather from last call:
stocksm %>% spread(stock, price)

         # time          X         Y          Z
# 1  2009-01-01 -0.1083095  3.910450 -7.2288668
# 2  2009-01-02  0.1131623  1.043821  0.2073273
# 3  2009-01-03  1.1011019 -2.214794 -3.3405555
# 4  2009-01-04  0.6682214  4.395654  5.1230922
# 5  2009-01-05 -0.9439180 -1.139381  1.0345520
# 6  2009-01-06  1.1424793  4.130842  4.4570703
# 7  2009-01-07 -0.3595520  1.708617 -2.6698576
# 8  2009-01-08  1.0357524  1.423007 -2.7228473
# 9  2009-01-09 -0.8674234  2.383576 -0.9256220
# 10 2009-01-10 -0.6661167 -1.067021  4.1033606


#retains stock col; turns time value into col headers with price as values
stocksm %>% spread(time, price)

  # stock 2009-01-01 2009-01-02 2009-01-03 2009-01-04 2009-01-05 2009-01-06 2009-01-07
# 1     X -0.1083095  0.1131623   1.101102  0.6682214  -0.943918   1.142479  -0.359552
# 2     Y  3.9104498  1.0438207  -2.214794  4.3956544  -1.139381   4.130842   1.708617
# 3     Z -7.2288668  0.2073273  -3.340556  5.1230922   1.034552   4.457070  -2.669858
  # 2009-01-08 2009-01-09 2009-01-10
# 1   1.035752 -0.8674234 -0.6661167
# 2   1.423007  2.3835761 -1.0670207
# 3  -2.722847 -0.9256220  4.1033606


# This script builds on the previous one by appending
# a call to spread(), which will allow us to turn the
# values of the test column, midterm and final, into
# column headers (i.e. variables).
#
# You only need to specify two arguments to spread().
# Can you figure out what they are? (Hint: You don't
# have to specify the data argument since we're using
# the %>% operator.
#
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread( test, grade) %>%
  print


    # name  class final midterm
# 1  Brian class1     B       B
# 2  Brian class5     C       A
# 3   Jeff class2     E       D
# 4   Jeff class4     C       A
# 5  Karen class3     C       C
# 6  Karen class4     A       A
# 7  Roger class2     A       C
# 8  Roger class5     A       B
# 9  Sally class1     C       A
# 10 Sally class3     C       B

# Lastly, we want the values in the class column to simply be 1, 2, ..., 5 and
# | not class1, class2, ..., class5. We can use the extract_numeric() function
# | from tidyr to accomplish this. To see how it works, try
# | extract_numeric("class5").

extract_numeric("class5")
# [1] 5

# We want the values in the class columns to be
# 1, 2, ..., 5 and not class1, class2, ..., class5.
#
# Use the mutate() function from dplyr along with
# extract_numeric(). Hint: You can "overwrite" a column
# with mutate() by assigning a new value to the existing
# column instead of creating a new column.
#
# Check out ?mutate and/or ?extract_numeric if you need
# a refresher.
#

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  mutate(class = extract_numeric(class))  %>%
  print


    # name class final midterm
# 1  Brian     1     B       B
# 2  Brian     5     C       A
# 3   Jeff     2     E       D
# 4   Jeff     4     C       A
# 5  Karen     3     C       C
# 6  Karen     4     A       A
# 7  Roger     2     A       C
# 8  Roger     5     A       B
# 9  Sally     1     C       A
# 10 Sally     3     C       B


# The fourth messy data problem we'll look at occurs when multiple
# observational units are stored in the same table. students4 presents an
# example of this. Take a look at the data now.

students4
    # id  name sex class midterm final
# 1  168 Brian   F     1       B     B
# 2  168 Brian   F     5       A     C
# 3  588 Sally   M     1       A     C
# 4  588 Sally   M     3       B     C
# 5  710  Jeff   M     2       D     E
# 6  710  Jeff   M     4       A     C
# 7  731 Roger   F     2       C     A
# 8  731 Roger   F     5       B     A
# 9  908 Karen   M     3       C     C
# 10 908 Karen   M     4       A     A


 # At first glance, there doesn't seem to be much of a problem with students4.
# All columns are variables and all rows are observations. However, notice that
# each id, name, and sex is repeated twice, which seems quite redundant. This
# is a hint that our data contains multiple observational units in a single
# table.

# Our solution will be to break students4 into two separate tables -- one
# containing basic student information (id, name, and sex) and the other
# containing grades (id, class, midterm, final).


# Complete the chained command below so that we are
# selecting the id, name, and sex column from students4
# and storing the result in student_info.
#
student_info <- students4 %>%
  select( id,name ,sex ) %>%
  print
    # id  name sex
# 1  168 Brian   F
# 2  168 Brian   F
# 3  588 Sally   M
# 4  588 Sally   M
# 5  710  Jeff   M
# 6  710  Jeff   M
# 7  731 Roger   F
# 8  731 Roger   F
# 9  908 Karen   M
# 10 908 Karen   M

#get rid of dup rows using unique():
student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print

   # id  name sex
# 1 168 Brian   F
# 3 588 Sally   M
# 5 710  Jeff   M
# 7 731 Roger   F
# 9 908 Karen   M


# select() the id, class, midterm, and final columns
# (in that order) and store the result in gradebook.
#

gradebook <- students4 %>%
  select(id, class, midterm, final) %>%
  print

   # id class midterm final
# 1  168     1       B     B
# 2  168     5       A     C
# 3  588     1       A     C
# 4  588     3       B     C
# 5  710     2       D     E
# 6  710     4       A     C
# 7  731     2       C     A
# 8  731     5       B     A
# 9  908     3       C     C
# 10 908     4       A     A


# The fifth and final messy data scenario that we'll address is when a single
# observational unit is stored in multiple tables. It's the opposite of the
# fourth problem.

# To illustrate this, we've created two datasets, passed and failed. Take a
# look at passed now.

 passed
   # name class final
# 1 Brian     1     B
# 2 Roger     2     A
# 3 Roger     5     A
# 4 Karen     4     A
  
failed
   # name class final
# 1 Brian     5     C
# 2 Sally     1     C
# 3 Sally     3     C
# 4  Jeff     2     E
# 5  Jeff     4     C
# 6 Karen     3     C


# Use dplyr's mutate() to add a new column to the passed table. The column
# should be called status and the value, "passed" (a character string), should
# be the same for all students. 'Overwrite' the current version of passed with
# the new one.


passed <- mutate(passed, status = "passed")
failed <- mutate(failed, status = "failed")


rbind_list(passed, failed)
    # name class final status
# 1  Brian     1     B passed
# 2  Roger     2     A passed
# 3  Roger     5     A passed
# 4  Karen     4     A passed
# 5  Brian     5     C failed
# 6  Sally     1     C failed
# 7  Sally     3     C failed
# 8   Jeff     2     E failed
# 9   Jeff     4     C failed
# 10 Karen     3     C failed



# | The SAT is a popular college-readiness exam in the United States that
# | consists of three sections: critical reading, mathematics, and writing.
# | Students can earn up to 800 points on each section. This dataset presents the
# | total number of students, for each combination of exam section and sex,
# | within each of six score ranges. It comes from the 'Total Group Report 2013',
# | which can be found here:
# | 
# | http://research.collegeboard.org/programs/sat/data/cb-seniors-2013

# | I've created a variable called 'sat' in your workspace, which contains data
# | on all college-bound seniors who took the SAT exam in 2013. Print the dataset
# | now.

sat

# Source: local data frame [6 x 10]

  # score_range read_male read_fem read_total math_male math_fem math_total
# 1   700â€“800     40151    38898      79049     74461    46040     120501
# 2     600-690    121950   126084     248034    162564   133954     296518
# 3     500-590    227141   259553     486694    233141   257678     490819
# 4     400-490    242554   296793     539347    204670   288696     493366
# 5     300-390    113568   133473     247041     82468   131025     213493
# 6     200-290     30728    29154      59882     18788    26562      45350
# Variables not shown: write_male (int), write_fem (int), write_total (int)


# Accomplish the following three goals:
#
# 1. select() all columns that do NOT contain the word "total",
# since if we have the male and female data, we can always
# recreate the total count in a separate column, if we want it.
# Hint: Use the contains() function, which you'll
# find detailed in 'Selection' section of ?select.
#
# 2. gather() all columns EXCEPT score_range, using
# key = part_sex and value = count.
#
# 3. separate() part_sex into two separate variables (columns),
# called "part" and "sex", respectively. You may need to check
# the 'Examples' section of ?separate to remember how the 'into'
# argument should be phrased.
#
sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  print

# Source: local data frame [36 x 4]

   # score_range  part  sex  count
# 1    700â€“800  read male  40151
# 2      600-690  read male 121950
# 3      500-590  read male 227141
# 4      400-490  read male 242554
# 5      300-390  read male 113568
# 6      200-290  read male  30728
# 7    700â€“800  read  fem  38898
# 8      600-690  read  fem 126084
# 9      500-590  read  fem 259553
# 10     400-490  read  fem 296793
# 11     300-390  read  fem 133473
# 12     200-290  read  fem  29154
# 13   700â€“800  math male  74461
# 14     600-690  math male 162564
# 15     500-590  math male 233141
# 16     400-490  math male 204670
# 17     300-390  math male  82468
# 18     200-290  math male  18788
# 19   700â€“800  math  fem  46040
# 20     600-690  math  fem 133954
# 21     500-590  math  fem 257678
# 22     400-490  math  fem 288696
# 23     300-390  math  fem 131025
# 24     200-290  math  fem  26562
# 25   700â€“800 write male  31574
# 26     600-690 write male 100963
# 27     500-590 write male 202326
# 28     400-490 write male 262623
# 29     300-390 write male 146106
# 30     200-290 write male  32500
# 31   700â€“800 write  fem  39101
# 32     600-690 write  fem 125368
# 33     500-590 write  fem 247239
# 34     400-490 write  fem 302933
# 35     300-390 write  fem 144381
# 36     200-290 write  fem  24933



# Append two more function calls to accomplish the following:
#
# 1. Use group_by() (from dplyr) to group the data by part and
# sex, in that order.
#
# 2. Use mutate to add two new columns, whose values will be
# automatically computed group-by-group:
#
#   * total = sum(count)
#   * prop = count / total
#
sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total = sum(count), prop = count/ total) %>% 
  print

# Source: local data frame [36 x 6]
# Groups: part, sex

   # score_range  part  sex  count  total       prop
# 1    700â€“800  read male  40151 776092 0.05173485
# 2      600-690  read male 121950 776092 0.15713343
# 3      500-590  read male 227141 776092 0.29267278
# 4      400-490  read male 242554 776092 0.31253253
# 5      300-390  read male 113568 776092 0.14633317
# 6      200-290  read male  30728 776092 0.03959324
# 7    700â€“800  read  fem  38898 883955 0.04400450
# 8      600-690  read  fem 126084 883955 0.14263622
# 9      500-590  read  fem 259553 883955 0.29362694
# 10     400-490  read  fem 296793 883955 0.33575578
# 11     300-390  read  fem 133473 883955 0.15099524
# 12     200-290  read  fem  29154 883955 0.03298132
# 13   700â€“800  math male  74461 776092 0.09594352
# 14     600-690  math male 162564 776092 0.20946486
# 15     500-590  math male 233141 776092 0.30040382
# 16     400-490  math male 204670 776092 0.26371873
# 17     300-390  math male  82468 776092 0.10626060
# 18     200-290  math male  18788 776092 0.02420847
# 19   700â€“800  math  fem  46040 883955 0.05208410
# 20     600-690  math  fem 133954 883955 0.15153939
# 21     500-590  math  fem 257678 883955 0.29150579
# 22     400-490  math  fem 288696 883955 0.32659581
# 23     300-390  math  fem 131025 883955 0.14822587
# 24     200-290  math  fem  26562 883955 0.03004904
# 25   700â€“800 write male  31574 776092 0.04068332
# 26     600-690 write male 100963 776092 0.13009154
# 27     500-590 write male 202326 776092 0.26069847
# 28     400-490 write male 262623 776092 0.33839158
# 29     300-390 write male 146106 776092 0.18825861
# 30     200-290 write male  32500 776092 0.04187648
# 31   700â€“800 write  fem  39101 883955 0.04423415
# 32     600-690 write  fem 125368 883955 0.14182622
# 33     500-590 write  fem 247239 883955 0.27969636
# 34     400-490 write  fem 302933 883955 0.34270183
# 35     300-390 write  fem 144381 883955 0.16333524
# 36     200-290 write  fem  24933 883955 0.02820619



##########################################
##########################################
#Lesson 4 - Dates and Times with lubridate
##########################################
##########################################

 # Unfortunately, due to different date and time representations, this lesson is
# | only guaranteed to work with an "en_US.UTF-8" locale. To view your locale,
# | type Sys.getlocale("LC_TIME").

Sys.getlocale("LC_TIME")

 # "English_United States.1252"

library(lubridate)
help(package = lubridate)


this_day <- today()
this_day
# [1] "2014-09-28"
 

year(this_day)
# [1] 2014 

month(this_day)
day(this_day)

wday(this_day)
# [1] 1

wday(this_day, label = TRUE)
# Sun
# Levels: Sun < Mon < Tues < Wed < Thurs < Fri < Sat



this_moment <- now()
this_moment
# [1] "2014-09-28 08:28:06 PDT"

year(this_moment)
month(this_moment)
day(this_moment)
wday(this_moment)

hour(this_moment)
#8

minute(this_moment)
second(this_moment)


# | today() and now() provide neatly formatted date-time information. When
# | working with dates and times 'in the wild', this won't always (and perhaps
# | rarely will) be the case.

# Fortunately, lubridate offers a variety of functions for parsing date-times.
# | These functions take the form of ymd(), dmy(), hms(), ymd_hms(), etc., where
# | each letter in the name of the function stands for the location of years (y),
# | months (m), days (d), hours (h), minutes (m), and/or seconds (s) in the
# | date-time being read in.

my_date <- ymd("1989-05-17")
my_date
# [1] "1989-05-17 UTC"

# | It looks almost the same, except for the addition of a time zone, which we'll
# | discuss later in the lesson. Below the surface, there's another important
# | change that takes place when lubridate parses a date. Type class(my_date) to
# | see what that is.

class(my_date)
# [1] "POSIXct" "POSIXt" 

# | So ymd() took a character string as input and returned an object of class
# | POSIXct. It's not necessary that you understand what POSIXct is, but just
# | know that it is one way that R stores date-time information internally.


# | "1989-05-17" is a fairly standard format, but lubridate is 'smart' enough to
# | figure out many different date-time formats. Use ymd() to parse "1989 May
# | 17". Don't forget to put quotes around the date!

ymd("1989 May 17")
# [1] "1989-05-17 UTC"


mdy("March 12, 1975")
# [1] "1975-03-12 UTC"

# | We can even throw something funky at it and lubridate will often know the
# | right thing to do. Parse 25081985, which is supposed to represent the 25th
# | day of August 1985. Note that we are actually parsing a numeric value here --
# | not a character string -- so leave off the quotes.

dmy(25081985)
# [1] "1985-08-25 UTC"


# | But be careful, it's not magic. Try ymd("192012") to see what happens when we
# | give it something more ambiguous. Surround the number with quotes again, just
# | to be consistent with the way most dates are represented (as character
# | strings).

ymd("192012")
# [1] NA
# Warning message:
# All formats failed to parse. No formats found. 

ymd("1920/1/2")
# [1] "1920-01-02 UTC"

# | In addition to dates, we can parse date-times. I've created a date-time
# | object called dt1. Take a look at it now.

dt1
# [1] "2014-08-23 17:23:02"

ymd_hms(dt1)
# [1] "2014-08-23 17:23:02 UTC"


# | What if we have a time, but no date? Use the appropriate lubridate function
# | to parse "03:22:14" (hh:mm:ss).

hms("03:22:14")
# [1] "3H 22M 14S"

# | lubridate is also capable of handling vectors of dates, which is particularly
# | helpful when you need to parse an entire column of data. I've created a
# | vector of dates called dt2. View its contents now.

dt2
# [1] "2014-05-14" "2014-09-22" "2014-07-11"


ymd(dt2)
# [1] "2014-05-14 UTC" "2014-09-22 UTC" "2014-07-11 UTC"

# | The update() function allows us to update one or more components of a
# | date-time. For example, let's say the current time is 08:34:55 (hh:mm:ss).
# | Update this_moment to the new time using the following command:
# | 
# | update(this_moment, hours = 8, minutes = 34, seconds = 55).

update(this_moment, hours = 8, minutes = 34, seconds = 55)
# [1] "2014-09-28 08:34:55 PDT"


 # Now, pretend you are in New York City and you are planning to visit a friend
# | in Hong Kong. You seem to have misplaced your itinerary, but you know that
# | your flight departs New York at 17:34 (5:34pm) the day after tomorrow. You
# | also know that your flight is scheduled to arrive in Hong Kong exactly 15
# | hours and 50 minutes after departure.


# | Let's reconstruct your itinerary from what you can remember, starting with
# | the full date and time of your departure. We will approach this by finding
# | the current date in New York, adding 2 full days, then setting the time to
# | 17:34.


# | To find the current date in New York, we'll use the now() function again.
# | This time, however, we'll specify the time zone that we want:
# | "America/New_York". Store the result in a variable called nyc. Check out ?now
# | if you need help.

?now
nyc <- now(tzone = "America/New_York")

# | For a complete list of valid time zones for use with lubridate, check out the
# | following Wikipedia page:
# | 
# | http://en.wikipedia.org/wiki/List_of_tz_database_time_zones


nyc
# [1] "2014-09-28 13:08:02 EDT"

# | Your flight is the day after tomorrow (in New York time), so we want to add
# | two days to nyc. One nice aspect of lubridate is that it allows you to use
# | arithmetic operators on dates and times. In this case, we'd like to add two
# | days to nyc, so we can use the following expression: nyc + days(2). Give it a
# | try, storing the result in a variable called depart.


depart <- nyc + days(2)
depart
# [1] "2014-09-30 13:08:02 EDT"

# So now depart contains the date of the day after tomorrow. Use update() to
# | add the correct hours (17) and minutes (34) to depart. Reassign the result to
# | depart.
depart <- update(depart, hours = 17, minutes = 34)
depart
# [1] "2014-09-30 17:34:02 EDT"

# | The first step is to add 15 hours and 50 minutes to your departure time.
# | Recall that nyc + days(2) added two days to the current time in New York. Use
# | the same approach to add 15 hours and 50 minutes to the date-time stored in
# | depart. Store the result in a new variable called arrive.

arrive <- depart + hours(15) + minutes(50)

# | The arrive variable contains the time that it will be in New York when you
# | arrive in Hong Kong. What we really want to know is what time is will be in
# | Hong Kong when you arrive, so that your friend knows when to meet you.


# | The with_tz() function returns a date-time as it would appear in another time
# | zone. Use ?with_tz to check out the documentation.


# | Use with_tz() to convert arrive to the "Asia/Hong_Kong" time zone. Reassign
# | the result to arrive, so that it will get the new value.

arrive <- with_tz(arrive, tzone = "Asia/Hong_Kong")
arrive
# [1] "2014-10-01 21:24:02 HKT"

# | Fast forward to your arrival in Hong Kong. You and your friend have just met
# | at the airport and you realize that the last time you were together was in
# | Singapore on June 17, 2008. Naturally, you'd like to know exactly how long it
# | has been.

# | Use the appropriate lubridate function to parse "June 17, 2008", just like
# | you did near the beginning of this lesson. This time, however, you should
# | specify an extra argument, tz = "Singapore". Store the result in a variable
# | called last_time.

last_time <- mdy("June 17, 2008", tz = "Singapore")
last_time
# [1] "2008-06-17 SGT"

# | Create a new_interval() that spans from last_time to arrive. Store it in a
# | new variable called how_long.
how_long <- new_interval(last_time, arrive)


as.period(how_long)
# [1] "6y 3m 14d 21H 24M 2.92133402824402S"
# Warning message:
# In Ops.factor(left, right) : - not meaningful for factors


# | This is where things get a little tricky. Because of things like leap years,
# | leap seconds, and daylight savings time, the length of any given minute, day,
# | month, week, or year is relative to when it occurs. In contrast, the length
# | of a second is always the same, regardless of when it occurs.

# | To address these complexities, the authors of lubridate introduce four
# | classes of time related objects: instants, intervals, durations, and periods.
# | These topics are beyond the scope of this lesson, but you can find a complete
# | discussion in the 2011 Journal of Statistical Software paper titled 'Dates
# | and Times Made Easy with lubridate'.


# | This concludes our introduction to working with dates and times in lubridate.
# | I created a little timer that started running in the background when you
# | began this lesson. Type stopwatch() to see how long you've been working!

stopwatch()
# [1] "2H 21M 48.700670003891S"

