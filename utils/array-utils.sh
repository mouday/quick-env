# 数组成员检查
# ref: https://www.cnblogs.com/wzc0066/p/14159506.html
# 逗号分隔数组
# in_array "one,two,three,four" "two"
# $(in_array ${A} "thre") == "true"
function in_array() {
    local list=`echo $1 | tr ',' ' '`
    local value=$2
    
    for var in ${list[@]}; do
        if [ $var == $value ]; then
            echo "true"
            return 0
        fi
    done

    echo "false"
    return 1
}
