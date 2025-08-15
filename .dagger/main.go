// A generated module for Demo functions
//
// This module has been generated via dagger init and serves as a reference to
// basic module structure as you get started with Dagger.
//
// Two functions have been pre-created. You can modify, delete, or add to them,
// as needed. They demonstrate usage of arguments and return types using simple
// echo and grep commands. The functions can be called from the dagger CLI or
// from one of the SDKs.
//
// The first line in this comment block is a short description line and the
// rest is a long description with more detail on the module's purpose or usage,
// if appropriate. All modules should have a short description.

package main

import (
	"context"
	"dagger/demo/internal/dagger"
)

type Demo struct{}

func (m *Demo) GoBuild(ctx context.Context,
	// +defaultPath="src/"
	source *dagger.Directory,
) *dagger.File {

	return dag.Go().WithSource(source).Build()
}

func getBuildContainer(ctx context.Context, source *dagger.Directory) *dagger.Container {
	buildContainer := dag.Container().
		From("golang:1.24.4").
		WithMountedDirectory("/work", source).
		WithWorkdir("/work")
	goModContents, err := buildContainer.File("go.mod").Contents(ctx)
	if goModContents != "" && err == nil {
		buildContainer = buildContainer.WithExec([]string{"go", "mod", "download"})
	}
	return buildContainer.WithExec([]string{"rm", "-rf", "/root/.cache/go-build"})
}
