# Matrix

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/coolpointerexception)

## Description

`cairo_matrix` is a library developed in Cairo language. It exposes a `Matrix` struct that can be used to store 2D arrays of any type.
```rust
#[storage]
struct Matrix<T> {
    data: Array<Array<T>>,
}
```

### Interface

```rust
trait MatrixTrait<T> {
    fn get_element(self: @Matrix<T>, row: u32, col: u32) -> T;
    fn min(self: @Matrix<T>) -> T;
    fn max(self: @Matrix<T>) -> T;
    fn new(data: @Array<T>, n_columns: u32) -> Matrix<T>;
    fn transpose(self: @Matrix<T>) -> Matrix<T>;
    fn add(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;
    fn sub(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;
    fn det(self: @Matrix<T>) -> T;
    fn dot(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;
    fn get_column(self: @Matrix<T>, col: u32) -> Array<T>;
    fn get_row(self: @Matrix<T>, r: u32) -> Array<T>;
}
```

### Usage

Import the library in yout toml file ([refer to Cairo documentation](https://book.cairo-lang.org/ch07-04-bringing-paths-into-scope-with-the-use-keyword.html#using-external-packages-in-cairo-with-scarb)):
```toml
[dependencies]
matrix = { git = "https://github.com/cairo-math/cairo-matrix.git" }
```

Then, you can use it in your code like:
```rust
use matrix::Matrix;

fn main() {
    let data = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    let matrix = Matrix::new(data, 3);
    let transposed = matrix.transpose();
}
```

### Bugs and Issues
If you find any bug or new feature request, please open an issue or a pull request. Any suggestion or improvement is welcome.