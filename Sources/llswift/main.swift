/*
   Copyright 2017 Ryuichi Saito, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation

import Source
import AST
import Parser

var filePaths = CommandLine.arguments
filePaths.remove(at: 0)

var sourceFiles = [SourceFile]()
if let filePath = filePaths.first {
  guard let sourceFile = try? SourceReader.read(at: filePath) else {
    print("Can't read file \(filePath)")
    exit(-1)
  }
  sourceFiles.append(sourceFile)
}

for sourceFile in sourceFiles {
  let parser = Parser(source: sourceFile)
  guard let topLevelDecl = try? parser.parse() else {
    exit(-2)
  }
  print(topLevelDecl.textDescription)
}

exit(0)
