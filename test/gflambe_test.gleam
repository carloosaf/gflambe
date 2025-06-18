import gflambe.{GflambeFunction}
import gleam/erlang/process
import gleam/string
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn apply_test() {
  gflambe.apply(
    fn() {
      let _ = string.append("hello", "world")
      Nil
    },
    [gflambe.OutputDirectory("./test")],
  )
}

pub fn capture_test() {
  process.spawn(fn() {
    process.sleep(400)
    string.append("hello", "world")
  })

  gflambe.capture(GflambeFunction("gleam@string", "append", 2), 1, [
    gflambe.OutputDirectory("./test"),
  ])
}
