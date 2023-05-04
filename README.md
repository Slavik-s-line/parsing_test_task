# parsing_test_task

## Extensions

* Ruby - 3.1.2p20
* Firefox browser (use in this case as default)
* selenium

## General info
> This script goes to the website https://minfin.com.ua/, logs in, searches for the necessary page with the NBU courses and reads all available courses. Than saves them in a separate json file called `answer.json`.

## Get started
- Clone this repository <br>
```
git clone https://github.com/Slavik-s-line/parsing_test_task.git
```
- Run gems installation 
```
bundle install
```
- Run script and test cases
```
rspec spec
```
- If you want to run the script without tests you should uncomment two last lines in file `spec/minfin_spec.rb` and run
```
ruby main.rb
```
- Don't start test cases with active two last lines in `spec/minfin_spec.rb`.