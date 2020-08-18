module Test.Enkuber where

import ClassyPrelude

import Enkuber
import Enkuber.Service
import Test.Tasty
import Test.Tasty.Golden

diffCommand :: FilePath -> FilePath ->[String]
diffCommand ref new = ["diff", "-u", ref, new]

tests :: TestTree
tests = testGroup "Enkuber"
  [ test_createKubeManifest
  ]

test_createKubeManifest :: TestTree
test_createKubeManifest = testGroup "createKubeManifest"
  [ test_simplestAlpha
  , test_simplestBeta
  ]

test_simplestAlpha :: TestTree
test_simplestAlpha = goldenVsStringDiff "simplest alpha" diffCommand "test/fixtures/golden/simplest/alpha.yaml" $ do
  let
    s = Service "alpha" "./test/fixtures/apps/simplest/alpha" ""
    project' = Project "Simple" "docker.io/kayhide/enkuber"
    x = createKubeManifest project' s
  pure $ encodeUtf8 $ fromStrict x

test_simplestBeta :: TestTree
test_simplestBeta = goldenVsStringDiff "simplest beta" diffCommand "test/fixtures/golden/simplest/beta.yaml" $ do
  let
    s = Service "beta" "./test/fixtures/apps/simplest/beta" ""
    project' = Project "Simple" "docker.io/kayhide/enkuber"
    x = createKubeManifest project' s
  pure $ encodeUtf8 $ fromStrict x
