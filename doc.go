package main

import (
	"bytes"
	"go/doc"
	"go/parser"
	"go/token"
	"os"
)

func main() {
	// Specify the package directory to generate documentation for
	dir := "."

	// Parse the package
	fset := token.NewFileSet()
	pkgs, err := parser.ParseDir(fset, dir, nil, parser.ParseComments)
	if err != nil {
		panic(err)
	}

	// Iterate over packages
	for _, pkg := range pkgs {
		// Generate documentation for each package
		docPkg := doc.New(pkg, dir, doc.AllDecls)
		var buf bytes.Buffer
		doc.ToHTML(&buf, docPkg.Doc, nil)
		htmlContent := buf.Bytes()

		// Write HTML content to file
		outputFile, err := os.Create("doc_java.html")
		if err != nil {
			panic(err)
		}
		defer outputFile.Close()
		_, err = outputFile.Write(htmlContent)
		if err != nil {
			panic(err)
		}
	}
}
