module Enkuber.Service where

import ClassyPrelude

import System.FilePath (takeBaseName)
import System.Directory (doesFileExist, listDirectory)

data Service
  = Service
  { name       :: Text
  , path       :: FilePath
  , dockerfile :: FilePath
  }
  deriving (Eq, Show, Generic)

findServices :: FilePath -> IO [Service]
findServices dir = do
  xs <- traverse (analyzeService . (dir </>)) . sort =<< listDirectory dir
  pure $ catMaybes xs

analyzeService :: FilePath -> IO (Maybe Service)
analyzeService path = do
  let
    name = pack $ takeBaseName path
    dockerfile = path </> "Dockerfile"
  bool Nothing (Just Service {..}) <$> doesFileExist dockerfile
