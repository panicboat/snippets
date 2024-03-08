package main

import (
	"fmt"
	"os/exec"
	"regexp"
)

func main() {
	match := matchTransientErrPattern("(OCI runtime create failed)", fmt.Errorf("StartError (exit code 128): failed to create containerd task: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error setting cgroup config for procHooks process: unable to freeze: unknown"))
	fmt.Println(match)
}

func matchTransientErrPattern(pattern string, err error) bool {
	match, _ := regexp.MatchString(pattern, generateErrorString(err))
	return match
}

func generateErrorString(err error) string {
	errorString := err.Error()
	if exitErr, ok := err.(*exec.ExitError); ok {
		errorString = fmt.Sprintf("%s %s", errorString, exitErr.Stderr)
	}
	return errorString
}
