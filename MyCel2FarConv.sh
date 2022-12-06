echo "Dose vathmous thermokrasias(Celsius h Fahrenheit):"
read t
echo "Dose monada metrisis thermokrasias(C h F):"
read m
case $m in
F)
b=`echo $t - 32 | bc`
c=`echo 5 \* $b | bc`
a=`echo "scale=2; $c / 9" | bc`
echo "H thermokrasia se Celsius einai: $a"
;;
C)
b=`echo "scale=2;9 / 5" | bc`
c=`echo $t \* $b | bc`
a=`echo $c + 32 | bc`
echo "H thermokrasia se Fahrenheit einai: $a"
esac
