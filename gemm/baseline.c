#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define M 128
#define N 128
#define K 128

// 初始化矩阵
void initialize_matrix(int matrix[M][K], int rows, int cols) {
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            matrix[i][j] = rand();
        }
    }
}

// 矩阵乘法 C = A * B
void matrix_multiply(int A[M][K], int B[K][N], int C[M][N]) {
    for (int i = 0; i < M; ++i) {
        for (int j = 0; j < N; ++j) {
            C[i][j] = 0;
            for (int k = 0; k < K; ++k) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

int main() {
    int A[M][K], B[K][N], C[M][N];

    // 初始化矩阵A和B
    initialize_matrix(A, M, K);
    initialize_matrix(B, K, N);

    // 计时开始

    clock_t start = clock();
    // 执行矩阵乘法

    matrix_multiply(A, B, C);
    // 计时结束
    clock_t end = clock();

    // 计算执行时间
    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    // 打印执行时间
    printf("Matrix multiplication took %f seconds\n", time_spent);

    return 0;
}