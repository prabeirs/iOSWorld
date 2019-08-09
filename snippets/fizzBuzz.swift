//“returns “Fizz” if the number is evenly divisible by 3, “Buzz” if it’s evenly divisible by 5, “FizzBuzz” if its evenly divisible by 3 and 5, or the original input number in other cases”
func fizzbuzz(number: Int) -> String {
    switch (number % 3 == 0, number % 5 == 0) {
    case (true, true):
        return "FizzBuzz"
    case (true, false):
        return "Fizz"
    case (false, true):
        return "Buzz"
//    case (false, false):
//        return String(number)
    default:
        return String(number)
    }
}
print(fizzbuzz(number: 15))
