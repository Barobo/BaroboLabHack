{-# LANGUAGE OverloadedStrings #-}

import Prelude
import qualified Prelude as P
import Data.Monoid (mempty)

import Text.Blaze.Html5
import qualified Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes hiding (challenge)
import qualified Text.Blaze.Html5.Attributes as A

import Text.Blaze.Html.Renderer.Pretty (renderHtml)

elem !. c = elem ! class_ c
elem !# i = elem ! A.id i

--
-- mini angular library
--
ngModel = customAttribute "ng-model"
ngIf = customAttribute "ng-if"
ngHide = customAttribute "ng-hide"
ngController = customAttribute "ng-controller"
ngApp = customAttribute "ng-app"
ngClass = customAttribute "ng-class"
ngShow = customAttribute "ng-show"


boilerplate navlist content scripts styles =
  let scripts' = mapM_ (\s -> script ! src s $ mempty) $ [
                    "js/robot_ids.js"
                    , "js/vendor/jquery-1.10.2.min.js"
                    , "js/vendor/bootstrap.min.js" ] ++ scripts
      styles' = mapM_ (\s -> link ! rel "stylesheet" ! href s) $ [
                    "css/bootstrap.min.css"
                    , "css/main.css" ] ++ styles
  in do
    docTypeHtml ! lang "en" $ do
        H.head $ do
            meta ! charset "utf-8"
            H.title "BaroboLab - DEMO"
            scripts'
            styles'
        body $ do
            nav ! class_ "app" $ do
                a ! href "index.html" $ img ! src "img/barobo_logo.png"
                ol ! class_ "nav nav-stacked nav-pills" $ sequence_ navlist
            content

boilerplate' n c = boilerplate n (section c) [] []

genHtml (file, html) = writeFile file $ renderHtml html

-- | Coerce that squirrely string literal
str :: String -> Html
str = toHtml

val :: String -> AttributeValue
val = toValue

labNavHdr =
    [ li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
    , li $ a ! href "chap6.html" $ "Chapter 6"
    , hr ! class_ "hdr"
    ]

labNavFtr =
    [ hr ! class_ "ftr"
    , li $ a ! href "lab_overview.html" $ small ! class_ "text-muted" $ "Overview"
    ]

labNav, labNavInner :: String -> [Html]

labNavInner title =
    [ li $ a ! href "setup.html" $ H.div $ do
        "6.1:"
        small "Cops vs. Robbers"
    , li ! class_ "active" $ a ! href "#" $ toHtml title
    ]

labNav title =
    labNavHdr ++
    (labNavInner title) ++
    labNavFtr

labOverviewNav = labNavHdr ++ (labNavInner "Overview")

index = boilerplate'
    -- Keep space for the nav on other pages
    [ li ! class_ "invisible" $ "foo" ]
    (do
        a ! href "holt.html"
            $ img ! class_ "textbook btn btn-default"
                  ! A.id "holt_img" ! src "img/holt_california.png"
        a ! href "#"
            $ img ! class_ "textbook btn btn-default disabled"
                  ! src "img/ca_common_core.png"
    )

holt = boilerplate'
    [ li ! class_ "active" $ a ! href "holt.html" $ img ! src "img/holt_california.png"
    ]
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        disabled "Chapter 1"
        disabled "Chapter 2"
        disabled "Chapter 3"
        disabled "Chapter 4"
        disabled "Chapter 5"
        li $ a ! href "chap6.html" $ "Chapter 6"
        disabled "Chapter 7"
        disabled "Chapter 8"
        disabled "Chapter 9"
        disabled "Chapter 10"
        disabled "Chapter 11"
        disabled "Chapter 12"
    )
  where
    disabled = (li !. "disabled") . (a ! href "#")

chap6 = boilerplate'
    [ li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
    , li ! class_ "active" $ a ! href "#" $ "Chapter 6"
    ]
    (ul ! class_ "sections nav nav-stacked nav-pills" $ do
        li $ a ! href "setup.html" ! A.title commonCoreWords $ do
            small "6.1"
            "Solving Systems by Graphing"
            small $ "(Common Core 5.1)"
        li' "6.2"
        li' "6.3"
        li' "6.4"
        li' "6.5"
    )
  where
    li' v = li !. "disabled" $ a ! href "#" $ small v
    commonCoreWords = val $
      "A-RE1.6; Solve systems of linear equations exactly and approximately "
      ++ "(e.g., with graphs) focusing on pairs of linear equations in two "
      ++ "variables."

section6_1 = boilerplate'
    [ li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
    , li $ a ! href "chap6.html" $ "Chapter 6"
    , li ! class_ "active" $ a ! href "#" $ "Section 6.1"
    ]
    (ul ! class_ "nav nav-stacked nav-pills" $ do
        li ! class_ "disabled" $ a ! href "#" $ "x vs. t"
        li $ a ! href "setup.html" $ "Cops vs. Robbers"
        li ! class_ "disabled" $ a ! href "#" $ "Slow Runners vs. Fast Runners"
    )

lab_overview = boilerplate'
    labOverviewNav
    (do
        table ! class_ "table table-striped overviewPics" $ do
            tr $ do
                td $ img ! src "img/labsetup.png"
                td $ H.div ! class_ "stepDescr" $ "Set up the lab."
            tr $ do
                td $ img ! src "img/prediction.png"
                td $ H.div ! class_ "stepDescr"
                    $ str $ "Read the question and introduce the charts. After "
                        ++ "entering a guess, press Next."
            tr $ do
                td $ img ! src "img/charts.png"
                td $ H.div ! class_ "stepDescr"
                    $ str $ "The robots will advance. The charts can be reset "
                        ++ "and students can guess again!"
        a ! class_ "pull-right btn btn-primary" ! href "setup.html" $ "Go to first step"
    )

charts = boilerplate
    (labNav "Prediction")
    (section $ do
        H.div ! class_ "row chartRow" $ do
            figure ! class_ "col-xs-3" $ do
                figcaption "Position"
                H.div ! A.id "pos" ! class_ "chart" $ mempty
            figure ! class_ "col-xs-8 col-xs-offset-1" $ do
                figcaption "Position vs. Time"
                H.div ! A.id "xvst" ! class_ "chart" $ mempty
                small ! class_ "xtitle" $ "time (s)"
        H.form ! class_ "form-inline" $ do
          H.div ! class_ "form-group" $ do
              H.label ! for "intersect" $ "When does the cop catch the robber?"
              input ! A.id "guess" ! type_ "text"
                    ! name "intersect"
          H.div ! class_ "form-group" $ do
              button ! class_ "btn btn-default" ! type_ "button" ! A.id "demoBtn" $ "Retry"
              button ! class_ "btn btn-info" ! type_ "button" ! A.id "resetBtn" $ "Reset"
              button ! class_ "btn btn-danger" ! type_ "button" ! A.id "stopBtn" $ "STOP!"
          H.div ! class_ "fwdBack" $ do
              a ! class_ "btn btn-default" ! href "prediction.html" $ "Back"
              a ! href "calculate_setup.html" ! class_ "pull-right btn btn-primary" $ "Next"
    )
    ["js/flot/jquery.flot.js", "js/vendor/bootbox.min.js", "js/copVsRobber.js"]
    []

setup = boilerplate'
    (labNav "Setup")
    (do
        dl $ do
            dt "The objective"
            dd $ str $ "Solve a system of linear equations in two variables"
                ++ " by graphing."
            dt "Vocabulary"
            dd $ H.ul $ do
                li "System of linear equations"
                li "Solution of a system of linear equations"
        p $ str $ "To run this curriculum application, please setup the "
            ++ "robots according to the following image."
        img ! src "img/setup.png" ! class_ "center-block fullContent"
        a ! href "prediction.html"
          ! class_ "pull-right btn btn-large btn-primary" $ "Next"
    )

prediction = boilerplate'
    (labNav "Prediction")
    (do
      p $ do
          "Suppose the"
          H.span ! A.style "color: blue" $ "cop"
          "Linkbot starts at position\n      -2 and the"
          H.span ! A.style "color: red" $ "robber"
          "Linkbot starts at position 4."
      p $ do
          str $ "The cop Linkbot travels at two meters per second (2 m/s), and "
            ++ "the robber Linkbot travels at half a meter per second (0.5 "
            ++ "m/s)."
      H.form ! action "charts.html" $ do
          H.div ! class_ "form-group" $ do
              H.label ! for "guess" $
                  "How long does it take the cop to catch the robber?"
              input ! class_ "form-control" ! type_ "text" ! name "intersect"
                    ! placeholder "time in seconds"
          input ! class_ "btn btn-primary pull-right" ! type_ "submit"
                ! value "Next"
      a ! href "setup.html" ! class_ "btn btn-default" $ "Back"
    )

calculateSetup = boilerplate
    (labNav "Calculate")
    (section $ do
        H.div !. "equations" $ do
            h4 "Setting up the equations for graphing"
            table $ do
                tr $ do
                    tdm "-x + 2y = 8"
                    tdm "-2x + y = -2"
                tr $ do
                    tdm "2y = x + 8"
                    tdm "y = 2x - 2"
                tr $ do
                    tdm "y = 1/2x + 4"
                    td mempty
                tr $ do
                    tdm "\\text slope = 1/2"
                    tdm "\\text slope = 2"
                tr $ do
                    tdm "\\text y-intercept = 4"
                    tdm "\\text y-intercept = -2"
        a ! href "calculate_chart.html"
          !. "pull-right btn btn-large btn-primary" $ "Next"
        a ! href "charts.html"
          !. "btn btn-large btn-default" $ "Back"
    )
    [ "js/vendor/jqmath-etc-0.4.0.min.js" ]
    [ "css/jqmath-0.4.0.css" ]
  where
    tdm m = td $ str $ "$" ++ m ++ "$"

calculateChart = boilerplate
    (labNav "Calculate")
    (section $ do
        H.div !. "infoHalf" $ do
            H.div !. "eqnTable" $ do
                table !. "equations" $ do
                    tr $ do
                        td "Robber:"
                        tdm "y = 1/2x + 4"
                    tr $ do
                        td "Cop:"
                        tdm "y = 2x - 2"

            H.div $ str $ "The solution of the system of linear equations"
                ++ " is the ordered pair $(4,6)$."
        H.div !. "chartHalf" $ do
            "This graph represents the system of equations."
            H.div !. "calc-chart-container" $ do
                H.div !# "calculation_chart" $ mempty
                H.span !# "xlabel" $ "6"
                H.span !# "ylabel" $ "4"
                H.span !# "intersect" $ "(4,6)"
        a ! href "explore.html"
          !. "pull-right btn btn-large btn-primary" $ "Next"
        a ! href "calculate_setup.html"
          !. "btn btn-large btn-default" $ "Back"

    )
    [ "js/vendor/jqmath-etc-0.4.0.min.js"
    , "js/flot/jquery.flot.js"
    , "js/calculate_chart.js" ]
    [ "css/jqmath-0.4.0.css"
    , "css/calculate_chart.css"
    ]
  where
    tdm m = td $ str $ "$" ++ m ++ "$"

--
-- Shared between explore and challenge:
--

tabLink link title =
  a ! href (val $ '#' : link) ! dataAttribute "toggle" "tab" $ title
numInput m = input ! type_ "number" ! maxlength "3" ! size "3"
                 ! A.max "99" ! A.min "-99" ! ngModel (val m)
control0 = control "0" num
control1 = control "1" num
control0' = control "0" num'
control1' = control "1" num'
control rob numFunc coeff jsVal variable =
    H.span
        ! activeControlClass rob coeff
        $ str $ (numFunc jsVal) ++ variable
activeControlClass rob n =
    ngClass $ val
            $ "{activeControl: selected["
                ++ rob ++ "] == " ++ n ++ "}"
num expr = "{{" ++ expr ++ "| number | plusMinus}}"
num' expr = "{{" ++ expr ++ "| number | plusMinus:true}}"
checkboxIf eqn = do
    H.div !. "eqnCheckboxYes" ! ngShow eqn $ do
        H.span !. "eqnCheckbox" $ "☑"
        "Yes!"
    H.div ! ngHide eqn $ do
        H.span !. "eqnCheckbox" $ "☐"
        "Not yet..."
breakdownLine hs =
    H.div $ do
        H.span !. "glyphicon glyphicon-arrow-right" $ mempty
        str $ concat hs

explore = boilerplate
    (labNav "Explore")
    (section ! ngApp "explore" ! ngController "Explore" $ do
        ul !. "nav nav-tabs" $ do
            li !. "active" $
                tabLink "standardForm" "Standard Form"
            li $
                tabLink "slopeInterceptForm" "Slope Intercept Form"
        H.div !. "tab-content" $ do
            H.div !# "standardForm" !. "tab-pane active"
                  ! ngController "StandardEqns" $ do
                H.div $ do
                    "Input a system of your choice."
                    exploreStandardEquations
                H.div !# "chartDisplay" ! ngController "Graph" $ do
                    H.div !. "chartGoesHere" $ mempty
            H.div !# "slopeInterceptForm" !. "tab-pane"
                  ! ngController "InterceptEqns" $ do
                H.div $ do
                    "Input a system of your choice."
                    exploreInterceptEquations
                H.div !# "chartDisplay" ! ngController "Graph" $ do
                    H.div !. "chartGoesHere" $ mempty
        a ! href "challenge.html"
          !. "next pull-right btn btn-large btn-primary" $ "Next"
        a ! href "calculate_chart.html"
          !. "back btn btn-large btn-default" $ "Back"
    )
    [ "js/vendor/angular.min.js"
    , "js/vendor/jqmath-etc-0.4.0.min.js"
    , "js/flot/jquery.flot.js"
    , "js/explore.js"
    ]
    [ "css/jqmath-0.4.0.css"
    , "css/explore.css"
    ]
  where
    exploreStandardEquations = do
        H.div !. "container-fluid" $ H.div !. "row" $ do
            eqnBreakdown "0" "leftEqn" "x1" "y1" "z1"
            eqnBreakdown "1" "rightEqn" "x2" "y2" "z2"
      where
        eqnBreakdown ctlNr id_ x y z =
            H.div !. "eqn-control col-xs-6" !# id_ $ do
                H.div ! ngHide "!mockRobot" $ do
                    numInput x
                    "x + "
                    numInput y
                    "y = "
                    numInput z
                H.div !. id_ $ do
                    control ctlNr num' "0" x "x"
                    control ctlNr num "1" y "y"
                    "="
                    control ctlNr num' "2" z ""
                H.div $ str $ num' y ++ "y = " ++ num' ("-" ++ x) ++ "x "
                                     ++ num z
                H.div $ str $ "y = " ++ num' ("-" ++ x ++ "/" ++ y) ++ "x "
                                     ++ num (z ++"/"++ y)
                H.div $ str $ "Slope = " ++ num' ("-" ++ x ++ "/" ++ y)
                H.div $ str $ "y-intercept = " ++ num' (z ++"/"++ y)
    exploreInterceptEquations = do
        H.div !. "container-fluid" $ H.div !. "row" $ do
            eqnBreakdown "0" "leftEqn" "a1" "b1"
            eqnBreakdown "1" "rightEqn" "a2" "b2"
      where
        eqnBreakdown ctlNr id_ a b =
            H.div !. "eqn-control col-xs-6" !# id_ $ do
                H.div ! ngHide "!mockRobot" $ do
                    "y = "
                    numInput a
                    "x + "
                    numInput b
                H.div !. id_ $ do
                    "y = "
                    control ctlNr num' "0" a "x"
                    control ctlNr num "1" b ""
                H.div $ str $ "Slope = " ++ num' a
                H.div $ str $ "y-intercept = " ++ num' b

challenge = boilerplate
    (labNav "Challenge")
    (section ! ngApp "challenge" ! ngController "Challenge" $ do
        ul !. "nav nav-tabs" $ do
            li !. "active" $
                tabLink "standardForm" "Standard Form Challenge"
            li $
                tabLink "slopeInterceptForm" "Slope Intercept Challenge"
        H.div !. "tab-content" $ do
            H.div !# "standardForm" !. "tab-pane active"
                  ! ngController "StandardEqns" $ do
                H.div !. "container-fluid" $ do
                    standardEquations
                chartDisplay
            H.div !# "slopeInterceptForm" !. "tab-pane"
                  ! ngController "InterceptEqns" $ do
                H.div $ do
                    interceptEquations
                chartDisplay
        a ! href "explore.html"
          !. "back btn btn-large btn-default" $ "Back"

    )
    [ "js/vendor/angular.min.js"
    , "js/vendor/jqmath-etc-0.4.0.min.js"
    , "js/flot/jquery.flot.js"
    , "js/challenge_.js"
    ]
    ["css/explore.css"]
  where
    chartDisplay = do
        H.div !# "chartDisplay" ! ngController "Graph" $ do
            H.div ! customAttribute "eqn-graph" ""
                  ! customAttribute "eqn-data" "serieses"
                  ! customAttribute "eqn-config" "chartCfg"
                  $ mempty
    standardEquations = do
        H.div $ str $ concat
            [ "Is (" , num' "solnX" , ", " , num' "solnY" , ") a solution?" ]
        H.div !. "row" $ do
            eqnBreakdown "0" "leftEqn" "x1" "y1" "z1"
            eqnBreakdown "1" "rightEqn" "x2" "y2" "z2"
      where
        eqnBreakdown ctlNr id_ x y z =
            H.div !. "eqn-control col-xs-6" !# id_ $ do
                H.div ! ngHide "!mockRobot" $ do
                    numInput x
                    "x + "
                    numInput y
                    "y = "
                    numInput z
                H.div !. id_ $ do
                    control ctlNr num' "0" x "x"
                    control ctlNr num  "1" y "y"
                    "= "
                    control ctlNr num' "2" z ""
                breakdownLine
                    [ num' x , "(" , num' "solnX" , ") " , num y
                    , "(" , num' "solnY" , ") = " , num' z ]
                breakdownLine
                    [ (num' $ x ++ " * solnX") , " " , (num $ y ++ " * solnY")
                    , " = " , num' z ]
                breakdownLine
                    [ (num' $ x ++ " * solnX + " ++ y ++ " * solnY")
                    , " = " , num' z ]
                checkboxIf eqn
          where
            eqn = val $ x ++ " * solnX + " ++ y ++ " * solnY == " ++ z
    interceptEquations = do
        H.div $ str $ concat
            [ "Is (" , num' "solnX" , ", " , num' "solnY" , ") a solution?" ]
        H.div !. "row" $ do
            eqnBreakdown "0" "leftEqn" "a1" "b1"
            eqnBreakdown "1" "rightEqn" "a2" "b2"
      where
        eqnBreakdown ctlNr id_ a b =
            H.div !. "eqn-control col-xs-6" !# id_ $ do
                H.div ! ngHide "!mockRobot" $ do
                    "y = "
                    numInput a
                    "x + "
                    numInput b
                H.div !. id_ $ do
                    "y = "
                    control ctlNr num' "0" a "x"
                    control ctlNr num "1" b ""
                breakdownLine
                    [ num' "solnY", " = ", num' a, "(", num' "solnX", ") "
                    , num b ]
                breakdownLine
                    [ num' "solnY", " = ", num' (a ++ "* solnX"), " ", num b ]
                breakdownLine $
                    (num' "solnY" ++ " = " ++ (num' $ a ++ " * solnX + " ++ b))
                    : []
                checkboxIf $ val $ "solnY == " ++ a ++ " * solnX + " ++ b

main = mapM_ genHtml [
    ("html/index.html", index)
    , ("html/holt.html", holt)
    , ("html/chap6.html", chap6)
    , ("html/section6-1.html", section6_1)
    , ("html/lab_overview.html", lab_overview)
    , ("html/charts.html", charts)
    , ("html/setup.html", setup)
    , ("html/prediction.html", prediction)
    , ("html/calculate_setup.html", calculateSetup)
    , ("html/calculate_chart.html", calculateChart)
    , ("html/explore.html", explore)
    , ("html/challenge.html", challenge)
    ]
