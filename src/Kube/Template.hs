{-# LANGUAGE TemplateHaskell #-}
module Kube.Template where

import ClassyPrelude

import Text.Mustache (Template)
import qualified Text.Mustache.Compile.TH as TH

service :: Template
service = $(TH.compileMustacheFile "src/Kube/service.yaml")

ingress :: Template
ingress = $(TH.compileMustacheFile "src/Kube/ingress.yaml")
