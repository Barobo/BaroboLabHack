{-# LANGUAGE OverloadedStrings #-}

import Prelude
import qualified Prelude as P
import Data.Monoid (mempty)

import Text.Blaze.Html5
import qualified Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes
import qualified Text.Blaze.Html5.Attributes as A

import Text.Blaze.Html.Renderer.Pretty (renderHtml)

boilerplate navlist content scripts =
  let scripts' = mapM_ (\s -> script ! src s $ mempty) $ [
                    "js/vendor/jquery-1.10.2.min.js"
                    , "js/vendor/bootstrap.min.js" ] ++ scripts
  in do
    docTypeHtml ! lang "en" $ do
        H.head $ do
            meta ! charset "utf-8"
            H.title "BaroboLab - DEMO"
            link ! rel "stylesheet" ! href "css/bootstrap.min.css"
            link ! rel "stylesheet" ! href "css/main.css"
        body $ do
            header $ a ! href "index.html" $ img ! src "img/barobo_logo.png"
            nav navlist
            section ! class_ "container" $ content
            scripts'

boilerplate' n c = boilerplate n c []

genHtml (file, html) = writeFile file $ renderHtml html

index = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills"
        $ li ! class_ "active"
        $ a ! href "index.html" $ "BaroboLab"
    )
    (do
        a ! href "holt.html"
            $ img ! class_ "textbook btn btn-default"
                  ! A.id "holt_img" ! src "img/holt_california.png"
        a ! href "#"
            $ img ! class_ "textbook btn btn-default disabled"
                  ! src "img/ca_common_core.png"
    )

holt = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li ! class_ "active" $ a ! href "holt.html" $ img ! src "img/holt_california.png"
    )
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li ! class_ "disabled" $ a ! href "#" $ "Chapter 1"
        li ! class_ "disabled" $ a ! href "#" $ "Chapter 2"
        li ! class_ "disabled" $ a ! href "#" $ "Chapter 3"
        li ! class_ "disabled" $ a ! href "#" $ "Chapter 4"
        li ! class_ "disabled" $ a ! href "#" $ "Chapter 5"
        li $ a ! href "chap6.html" $ "Chapter 6"
    )

chap6 = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
        li ! class_ "active" $ a ! href "#" $ "Chapter 6"
    )
    (ul ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "section6-1.html" $ "6.1"
        li ! class_ "disabled" $ a ! href "#" $ "6.2"
        li ! class_ "disabled" $ a ! href "#" $ "6.3"
        li ! class_ "disabled" $ a ! href "#" $ "6.4"
        li ! class_ "disabled" $ a ! href "#" $ "6.5"
    )

section6_1 = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
        li $ a ! href "chap6.html" $ "Chapter 6"
        li ! class_ "active" $ a ! href "#" $ "Section 6.1"
    )
    (ul ! class_ "nav nav-stacked nav-pills" $ do
        li ! class_ "disabled" $ a ! href "#" $ "x vs. t"
        li $ a ! href "copVsRobber.html" $ "Cops vs. Robbers"
        li ! class_ "disabled" $ a ! href "#" $ "Slow Runners vs. Fast Runners"
    )

copVsRobber = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
        li $ a ! href "chap6.html" $ "Chapter 6"
        li $ a ! href "section6-1.html" $ "Section 6.1"
        li ! class_ "active" $ a ! href "#" $ "Cops vs. Robbers"
    )
    (do
        a ! href "page4.html" ! class_ "btn btn-primary btn-block btn-lg" $ "Run Lab"
        a ! href "lab_overview.html" ! class_ "btn btn-info btn-block" $ "View overview"
    )

lab_overview = boilerplate'
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
        li $ a ! href "chap6.html" $ "Chapter 6"
        li $ a ! href "section6-1.html" $ "Section 6.1"
        li $ a ! href "copVsRobber.html" $ "Cops vs. Robbers"
        li ! class_ "active" $ a ! href "#" $ "Lab Overview"
    )
    (do
        h2 "Overview"
        table ! class_ "table table-striped overviewPics" $ do
            tr $ do
                td $ img ! src "img/labsetup.png"
                td $ H.div ! class_ "stepDescr" $ "Set up the lab."
            tr $ do
                td $ img ! src "img/prediction.png"
                td $ H.div ! class_ "stepDescr"
                    $ toHtml ("Read the question and introduce the charts. After "
                        ++ "entering a guess, press Next." :: String)
            tr $ do
                td $ img ! src "img/charts.png"
                td $ H.div ! class_ "stepDescr"
                    $ toHtml ("The barfs robots will advance. The charts can be reset "
                        ++ "and students can guess again!" :: String)
            tr $ do
                td $ img ! src "img/equations.png"
                td $ H.div ! class_ "stepDescr" $ "Now you'll do things with equations, I guess."
        a ! class_ "btn btn-default" ! href "page4.html" $ "Go to first step"
    )

charts = boilerplate
    (ol ! class_ "nav nav-stacked nav-pills" $ do
        li $ a ! href "index.html" $ "BaroboLab"
        li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
        li $ a ! href "chap6.html" $ "Chapter 6"
        li $ a ! href "section6-1.html" $ "Section 6.1"
        li $ a ! href "copVsRobber.html" $ "Cops vs. Robbers"
        li ! class_ "active" $ a ! href "#" $ "Charts"
    )
    (do
        H.div ! class_ "row chartRow" $ do
            figure ! class_ "col-xs-3" $ do
                figcaption "Position"
                H.div ! A.id "pos" ! class_ "chart" $ mempty
            figure ! class_ "col-xs-8 col-xs-offset-1" $ do
                figcaption "Position vs. Time"
                H.div ! A.id "xvst" ! class_ "chart" $ mempty
                small ! class_ "xtitle" $ "time (s)"
        "Intersect after:"
        input ! A.id "guess" ! type_ "text" ! name "intersect"
        "seconds"
        br
        button ! class_ "btn btn-default" ! type_ "button" ! A.id "demoBtn" $ "Retry"
        button ! class_ "btn btn-info" ! type_ "button" ! A.id "resetBtn" $ "Reset"
        button ! class_ "btn btn-danger" ! type_ "button" ! A.id "stopBtn" $ "STOP!"
        a ! href "equations.html" ! class_ "pull-right btn btn-primary btn-lg" $ "Next"
    )
    ["js/flot/jquery.flot.js", "js/copVsRobber.js"]

page4 = do
    docType
    -- [if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]
    -- [if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]
    -- [if IE 8]>         <html class="no-js lt-ie9"> <![endif]
    -- [if gt IE 8]><!
    html ! class_ "no-js" $ do
        -- <![endif]
        H.head $ do
            meta ! charset "utf-8"
            meta ! httpEquiv "X-UA-Compatible" ! content "IE=edge"
            H.title "BaroboLab - DEMO"
            meta ! name "description" ! content ""
            meta ! name "viewport" ! content "width=device-width, initial-scale=1"
            --  Place favicon.ico and apple-touch-icon.png in the root directory 
            link ! rel "stylesheet" ! href "css/bootstrap.min.css"
            link ! rel "stylesheet" ! href "css/main.css"
            script ! src "js/vendor/modernizr-2.6.2.min.js" $ mempty
        body $ do
            nav $ do
                header $ img ! src "img/barobo_logo.png"
                ol ! class_ "nav nav-stacked nav-pills" $ do
                    li $ a ! href "index.html" $ "BaroboLab"
                    li $ a ! href "holt.html" $ img ! src "img/holt_california.png"
                    li $ a ! href "chap6.html" $ "Chapter 6"
                    li $ a ! href "section6-1.html" $ "Section 6.1"
                    hr
                    li $ a ! href "copVsRobber.html" $ "Cops vs. Robbers"
                    li ! class_ "active" $ a ! href "#" $ "Setup"
                    hr
                    li $ a ! href "lab_overview.html" $ small ! class_ "text-muted" $ "Overview"
            section ! class_ "container" $ do
                h2 "Lab Setup"
                p "To run this curriculum application, please setup the robots according to the following image."
                a ! href "prediction.html" ! class_ "btn btn-large btn-primary" $ "Next"
                br
                img ! src "img/setup.png" ! A.style "width:1024px; height:768px;"


main = mapM_ genHtml [
    ("html/index.html", index)
    , ("html/holt.html", holt)
    , ("html/chap6.html", chap6)
    , ("html/section6-1.html", section6_1)
    , ("html/copVsRobber.html", copVsRobber)
    , ("html/lab_overview.html", lab_overview)
    , ("html/charts.html", charts)
    , ("html/page4.html", page4)
    ]
