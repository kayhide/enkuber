module Enkuber where

import ClassyPrelude

import Data.Aeson ((.=))
import qualified Data.Aeson as Aeson
import Enkuber.Service
import qualified Kube.Template as Kube
import System.Process.Typed (readProcess_, setWorkingDir)
import Text.Mustache (renderMustache)

run :: IO ()
run = do
  putStrLn "Enkuber!"

  services <- findServices simplestDir

  let
    project' = Project "Simple" "docker.io/kayhide/enkuber"
    xs = createKubeManifest project' <$> services
  traverse_ say xs



simplestDir :: FilePath
simplestDir = "./test/fixtures/apps/simplest"

data Project
  = Project
  { project :: Text
  , image :: Text
  }
  deriving (Eq, Show, Generic)

buildImage :: Project -> Service -> IO ()
buildImage Project { project, image } Service { name, path } = do
  let
    image_tag = intercalate "-" ([toLower project, toLower name] :: [Text])
    command = "docker build --tag " <> image <> ":" <> image_tag <> " ."
  say command
  (out, err) <- readProcess_
    $ setWorkingDir path
    $ fromString $ unpack command

  say $ toStrict $ decodeUtf8 out
  say $ toStrict $ decodeUtf8 err

createKubeManifest :: Project -> Service -> Text
createKubeManifest Project {..} Service {..} = do
  let
    image_tag = "simplest-" <> name
    obj = Aeson.object
      [ "name" .= name
      , "image" .= image
      , "image_tag" .= image_tag
      ]
  toStrict $ renderMustache Kube.service obj
