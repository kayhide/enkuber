module Enkuber where

import ClassyPrelude

import Data.Aeson ((.=))
import qualified Data.Aeson as Aeson
import qualified Kube.Template as Kube
import System.Directory (doesDirectoryExist, doesFileExist, listDirectory)
import System.Process.Typed (readProcess_, setWorkingDir)
import Text.Mustache (renderMustache)

run :: IO ()
run = do
  putStrLn "Enkuber!"

  services <- sortOn name <$> findServices simplestDir

  let
    xs = createKubeManifest <$> services
  traverse_ say xs



project :: Text
project = "Simplest"

simplestDir :: FilePath
simplestDir = "./test/fixtures/apps/simplest"

image :: Text
image = "docker.io/kayhide/enkuber"


data Service
  = Service
  { name       :: Text
  , path       :: FilePath
  , dockerfile :: FilePath
  , image_tag  :: Text
  }
  deriving (Eq, Show, Generic)

findServices :: FilePath -> IO [Service]
findServices dir = do
  let fromName x = do
        let
          name = pack x
          path = dir </> x
          dockerfile = dir </> x </> "Dockerfile"
          image_tag = "simplest-" <> name
        bool Nothing (Just Service {..}) <$> doesFileExist dockerfile

  xs <- traverse fromName =<< listDirectory dir
  pure $ catMaybes xs


buildImage :: Service -> IO ()
buildImage Service { path, image_tag } = do
  let
    command = "docker build --tag " <> image <> ":" <> image_tag <> " ."
  say command
  (out, err) <- readProcess_
    $ setWorkingDir path
    $ fromString $ unpack command

  say $ toStrict $ decodeUtf8 out
  say $ toStrict $ decodeUtf8 err

createKubeManifest :: Service -> Text
createKubeManifest Service {..} = do
  let
    obj = Aeson.object
      [ "name" .= name
      , "image" .= image
      , "image_tag" .= image_tag
      ]
  toStrict $ renderMustache Kube.service obj
