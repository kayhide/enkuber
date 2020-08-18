module Test.Enkuber.Service where

import ClassyPrelude

import Enkuber.Service
import Test.Tasty
import Test.Tasty.HUnit


tests :: TestTree
tests = testGroup "Enkuber.Service"
  [ unit_findServices
  , unit_analyzeService
  ]

unit_findServices :: TestTree
unit_findServices = testGroup "findServices"
  [ testCase "finds services" $ do
      let
        dir = "./test/fixtures/apps/simplest"
      ss <- findServices dir
      name <$> ss @?= ["alpha", "beta"]
  ]

unit_analyzeService :: TestTree
unit_analyzeService =
  testGroup "analizeService"
  [ testCase "creates Service alpha" $ do
      let
        path' = "./test/fixtures/apps/simplest/alpha"
      Just Service { name, path } <- analyzeService path'
      name @?= "alpha"
      path @?= path'

  , testCase "creates Service beta" $ do
      let
        path' = "./test/fixtures/apps/simplest/beta"
      Just Service { name, path } <- analyzeService path'
      name @?= "beta"
      path @?= path'
  ]
