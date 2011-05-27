{-# LANGUAGE OverloadedStrings #-}
module Hakyll.Core.UnixFilter.Tests
    where

import Control.Arrow ((>>>))
import qualified Data.Map as M

import Test.Framework (Test)
import Test.Framework.Providers.HUnit (testCase)
import qualified Test.HUnit as H
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL

import Hakyll.Core.Compiler
import Hakyll.Core.Resource.Provider.Dummy
import Hakyll.Core.UnixFilter
import TestSuite.Util

tests :: [Test]
tests =
    [ testCase "unixFilter rev" unixFilterRev
    ]

unixFilterRev :: H.Assertion
unixFilterRev = do
    provider <- dummyResourceProvider $ M.singleton "foo" $
        TL.encodeUtf8 $ TL.pack text
    output <- runCompilerJobTest compiler "foo" provider ["foo"]
    H.assert $ rev text == lines output
  where
    compiler = getResource >>> getResourceString >>> unixFilter "rev" []
    rev = map reverse . lines

text :: String
text = unlines
    [ "Статья 18"
    , ""
    , "Каждый человек имеет право на свободу мысли, совести и религии; это"
    , "право включает свободу менять свою религию или убеждения и свободу"
    , "исповедовать свою религию или убеждения как единолично, так и сообща с"
    , "другими, публичным или частным порядком в учении, богослужении и"
    , "выполнении религиозных и ритуальных обрядов."
    , ""
    , "Статья 19"
    , ""
    , "Каждый человек имеет право на свободу убеждений и на свободное выражение"
    , "их; это право включает свободу беспрепятственно придерживаться своих"
    , "убеждений и свободу искать, получать и распространять информацию и идеи"
    , "любыми средствами и независимо от государственных границ."
    ]