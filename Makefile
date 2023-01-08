# 打包-包括缓存
.PHONY: build-full
build-full:
	@mkdir -p ./build
	@tar -zcf "./build/quick-env-full.tar.gz" \
	--exclude .git \
	--exclude build \
	--exclude Makefile \
	--exclude .gitignore \
	--exclude .DS_Store ./
	@echo 'build success'

# 打包-不包括缓存
.PHONY: build
build:
	@mkdir -p ./build
	@tar -zcf "./build/quick-env.tar.gz" \
	--exclude cache \
	--exclude .git \
	--exclude build \
	--exclude Makefile \
	--exclude .gitignore \
	--exclude .DS_Store ./
	@echo 'build success'

# 清空打包产物
.PHONY: clean
clean:
	@rm -rf ./build
	@echo 'clean success'
