# Create the `environment` file by concatenating the `environment.d` files.
awk 'FNR==1 && NR!=1 {print "\n##########################################################################\n"}{print}' environment.d/*.txt > environment
