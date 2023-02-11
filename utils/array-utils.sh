# 数组成员检查
# ref: https://www.cnblogs.com/wzc0066/p/14159506.html
# 逗号分隔数组
# eg:
# if [ $(in_array "one,two,three,four" "two") == "true" ]; then
#   # do something
# fi
function in_array() {
    if [ ! $1 ]; then
        echo "false"
        return 1
    fi

    if [ ! $2 ]; then
        echo "false"
        return 1
    fi

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
