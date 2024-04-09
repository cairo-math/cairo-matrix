#[derive(Drop, PartialOrd)]
struct Matrix<T> {
    data: Array<Array<T>>,
}

impl MatrixCopy<T, +Copy<T>, +Copy<Array<T>>, +Copy<Array<Array<T>>>> of core::traits::Copy::<Matrix<T>>;

trait MatrixTrait<T> {
    // Returns the element at the specified row and column
    fn get_element(self: @Matrix<T>, row: u32, col: u32) -> T;

    // Returns the minimum value in the matrix
    fn min(self: @Matrix<T>) -> T;

    // Returns the maximum value in the matrix
    fn max(self: @Matrix<T>) -> T;

    // Constructs a new matrix from a 1D array.
    // Example:
    // input: data = [1, 2, 3, 4, 5, 6], n_columns = 2
    // output: [[1, 2], [3, 4], [5, 6]]
    fn new(data: @Array<T>, n_columns: u32) -> Matrix<T>;

    // Transposes the matrix
    // Example:
    // input: [[1, 2, 3], [4, 5, 6]]
    // output: [[1, 4], [2, 5], [3, 6]]
    fn transpose(self: @Matrix<T>) -> Matrix<T>;

    // Adds two matrices
    // Example:
    // input: self.data = [[1, 2], [3, 4]], other.data = [[5, 6], [7, 8]]
    // output: [[6, 8], [10, 12]]
    fn add(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;

    // Subtracts two matrices
    // Example:
    // input: self.data = [[1, 2], [3, 4]], other.data = [[1, 2], [3, 4]]
    // output: [[0, 0], [0, 0]]
    fn sub(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;

    // Calculate determinant of the matrix
    // Example:
    // input: [[1, 2, 2], [0, 5, 7], [1, 1, 1]]
    // output: 2
    fn det(self: @Matrix<T>) -> T;

    // Calculate dot product of two matrices
    // Example:
    // input: self.data = [[1, 2], [3, 4]], other.data = [[5, 6], [7, 8]]
    // output: [[19, 22], [43, 50]]
    fn dot(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T>;
    
    // Return column
    fn get_column(self: @Matrix<T>, col: u32) -> Array<T>;

    // Return row
    fn get_row(self: @Matrix<T>, r: u32) -> Array<T>;
}

impl MatrixImpl<T, +PartialOrd<T>, +Copy<T>, +Drop<T>, +Add<T>, +Sub<T>, +Mul<T>, +AddEq<T>, +SubEq<T>, +TryInto<felt252, T>> of MatrixTrait<T> {

    fn get_element(self: @Matrix<T>, row: u32, col: u32) -> T {
        return *self.data.at(row).at(col);
    }

    fn min(self: @Matrix<T>) -> T {
        let mut min_val = *self.data.at(0).at(0);
        let mut i = 0;
        let rows = self.data.len();

        while i != rows {
            let cols = self.data.at(i).len();
            let mut j = 0;
            while j != cols {
                let current_val = *self.data.at(i).at(j);
                if current_val < min_val {
                    min_val = current_val;
                }
                j += 1;
            };
            i += 1;
        };

        return min_val;
   }

    fn max(self: @Matrix<T>) -> T {
        let mut max_val = *self.data.at(0).at(0);
        let rows = self.data.len();
        let mut i = 0;

        while i != rows {
            let cols = self.data.at(i).len();
            let mut j = 0;
            while j != cols {
                let current_val = *self.data.at(i).at(j);
                if current_val > max_val {
                    max_val = current_val;
                }
                j += 1;
            };
            i += 1;
        };
        
        return max_val;
    }

    fn new(data: @Array<T>, n_columns: u32) -> Matrix<T> {
        assert!(data.len() % n_columns == 0, "Data length must be divisible by n_columns");

        let mut arr: Array<Array<T>> = array![];
        let mut i = 0;
        let mut j = 0;
        let mut row: Array<T> = array![];

        while i != data.len() {
            row.append(*data.at(i));
            j += 1;
            if j == n_columns {
                arr.append(row);
                row = array![];
                j = 0;
            }
            i += 1;
        };

        return Matrix { data: arr };
        
    }

    fn transpose(self: @Matrix<T>) -> Matrix<T> {
        let rows = self.data.len();
        let cols = self.data.at(0).len();
        let mut transposed_data: Array<T> = array![];
        let mut j = 0;

        while j != cols {
            let mut i = 0;
            while i != rows {
                let element = *self.data.at(i).at(j);
                transposed_data.append(element);
                i += 1;
            };
            j += 1;
        };

        return MatrixTrait::new(@transposed_data, rows);
    }

    fn add(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T> {
        //check if the matrices have the same dimensions
        assert!(self.data.len() == other.data.len(), "Matrices must have the same number of rows");
        assert!(self.data.at(0).len() == other.data.at(0).len(), "Matrices must have the same number of columns");
        
        let mut result_data: Array<Array<T>> = array![];
        
        let rows = self.data.len();
        let mut i = 0;

        while i != rows {
            let mut row_result: Array<T> = array![];
            let cols = self.data.at(i).len();
            let mut j = 0;
            while j != cols {
                let sum = *self.data.at(i).at(j) + *other.data.at(i).at(j);
                row_result.append(sum);
                j += 1;
            };
            result_data.append(row_result);
            i += 1;
        };
        
        return Matrix { data: result_data };
    }

    fn sub(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T> {
        //check if the matrices have the same dimensions
        assert!(self.data.len() == other.data.len(), "Matrices must have the same number of rows");
        assert!(self.data.at(0).len() == other.data.at(0).len(), "Matrices must have the same number of columns");
        
        let mut result_data: Array<Array<T>> = array![];
        
        let rows = self.data.len();
        let mut i = 0;

        while i != rows {
            let mut row_result: Array<T> = array![];
            let cols = self.data.at(i).len();
            let mut j = 0;
            while j != cols {
                let sum = *self.data.at(i).at(j) - *other.data.at(i).at(j);
                row_result.append(sum);
                j += 1;
            };
            result_data.append(row_result);
            i += 1;
        };
        
        return Matrix { data: result_data };
    }

    fn det(self: @Matrix<T>) -> T {
        let rows = self.data.len();
        let cols = self.data.at(0).len();
        assert!(rows == cols, "Matrix must be square");

        if rows == 1 {
            return *self.data.at(0).at(0);
        } else if rows == 2 {
            return *self.data.at(0).at(0) * *self.data.at(1).at(1) - *self.data.at(0).at(1) * *self.data.at(1).at(0);
        } else {
            let mut tmpDet: T = 0.try_into().unwrap();
            let mut i = 0;
            while i != cols {
                let mut sub_matrix_data: Array<T> = array![];
                let mut j = 1;
                while j != rows {
                    let mut k = 0;
                    while k != cols {
                        if k != i {
                            sub_matrix_data.append(*self.data.at(j).at(k));
                        }
                        k += 1;
                    };
                    j += 1;
                };
                let sub_matrix = MatrixTrait::new(@sub_matrix_data, cols - 1);
                if i % 2 == 0 {
                    tmpDet += *self.data.at(0).at(i) * sub_matrix.det();
                } else {
                    tmpDet -= *self.data.at(0).at(i) * sub_matrix.det();
                }
                i += 1;
            };
            return tmpDet;
        }
    }

    fn dot(self: @Matrix<T>, other: @Matrix<T>) -> Matrix<T> {
        let rows = self.data.len();
        let cols = self.data.at(0).len();
        assert!(rows == other.data.len(), "Matrices must have the same number of rows");
        assert!(cols == other.data.at(0).len(), "Matrices must have the same number of columns");

        let mut result_data: Array<T> = array![];
        let mut i = 0;

        while i != rows {
            let mut j = 0;
            while j != cols {
                let mut k = 0;
                let mut sum: T = 0.try_into().unwrap();
                while k != cols {
                    sum += *self.data.at(i).at(k) * *other.data.at(k).at(j);
                    k += 1;
                };
                result_data.append(sum);
                j += 1;
            };
            i += 1;
        };

        return MatrixTrait::new(@result_data, cols);
    }

    fn get_column(self: @Matrix<T>, col: u32) -> Array<T> {
        let mut column: Array<T> = array![];
        let rows = self.data.len();
        let mut i = 0;

        while i != rows {
            column.append(*self.data.at(i).at(col));
            i += 1;
        };

        return column;
    }

    fn get_row(self: @Matrix<T>, r: u32) -> Array<T> {
        let mut row: Array<T> = array![];
        let cols = self.data.at(0).len();
        let mut i = 0;

        while i != cols {
            row.append(*self.data.at(r).at(i));
            i += 1;
        };

        return row;
    }
}


fn main() {
    let arr: Array<i32> = array![11, -2, 3, 4, 5, 6, 7, 8, 9, 10];
    let matrix = MatrixTrait::new(@arr, 2);
    assert!(matrix.get_element(1, 1) == 4, "Expecting 4");
    assert!(matrix.min() == -2, "Expecting -2");
    assert!(matrix.max() == 11, "Expecting 11");
    let m = matrix.transpose();
    assert!(m.get_element(0, 0) == 11, "Expecting 11");
    assert!(m.get_element(0, 1) == 3, "Expecting 3");
    assert!(m.get_element(0, 2) == 5, "Expecting 5");
    assert!(m.get_element(0, 3) == 7, "Expecting 7");
    assert!(m.get_element(0, 4) == 9, "Expecting 9");
    assert!(m.get_element(1, 0) == -2, "Expecting -2");
    assert!(m.get_element(1, 1) == 4, "Expecting 4");
    assert!(m.get_element(1, 2) == 6, "Expecting 6");
    assert!(m.get_element(1, 3) == 8, "Expecting 8");
    assert!(m.get_element(1, 4) == 10, "Expecting 10");

    let a: Array<i32> = array![1, 2, 3, 4, 5, 6, 7, 8, 9];
    let m1 = MatrixTrait::new(@a, 3);
    let m2 = MatrixTrait::new(@a, 3);
    let m3 = m1.add(@m2);
    assert!(m3.get_element(0, 0) == 2, "Expecting 2");
    assert!(m3.get_element(2, 2) == 18, "Expecting 18");

    let m4 = m1.sub(@m2);
    assert!(m4.get_element(0, 0) == 0, "Expecting 0");
    assert!(m4.get_element(2, 2) == 0, "Expecting 0");

    let b: Array<i32> = array![1, 2, 2, 0, 5, 7, 1, 1, 1];
    let m5 = MatrixTrait::new(@b, 3);
    assert!(m5.det() == 2, "Expecting 2");

    let m6 = MatrixTrait::new(@a, 3);
    assert!(m6.get_column(1) == array![2, 5, 8], "Expecting [2, 5, 8]");
    assert!(m6.get_row(1) == array![4, 5, 6], "Expecting [4, 5, 6]");
}