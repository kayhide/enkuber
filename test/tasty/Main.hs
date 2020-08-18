module Main where

import ClassyPrelude
import Test.Tasty
import qualified Test.Enkuber
import qualified Test.Enkuber.Service

main :: IO ()
main = defaultMain $ testGroup "Test"
  [ Test.Enkuber.tests
  , Test.Enkuber.Service.tests
  ]

