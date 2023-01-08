##################################
# 打印可安装的软件名称
##################################

function echo_install_names(){
    echo "install support:"
    install_files=`ls ${QUICK_ENV_INCLUDE} | grep 'install-*'`

    for install_file in $install_files; do
        re="install-(.*).sh"
        if [[ $install_file =~ $re ]]; then 
            echo "  ${BASH_REMATCH[1]}"
        fi
    done
}