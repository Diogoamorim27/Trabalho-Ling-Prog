*Adicionar o cpr:
(dentro de Trabalho-Ling-Prog/cpp)

git submodule add git@github.com:whoshuu/cpr.git
OU 
git submodule add https://github.com/whoshuu/cpr.git

git submodule update --init --recursive


*Buildar o cpr:

cd cpr
mkdir build
cd build
cmake ..
make
cd ../.. (voltar para cpp)


*Compilar:

g++ -Wall -std=c++11 -I cpr/include/ -L cpr/build/lib/ example.cpp -lcpr -lcurl -lgtest -lgtest_main -lmongoose -ltest_server -o example
