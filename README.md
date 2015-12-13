alt-ruby
====

Overview

## Description

"update-alternatives" でrubyのバージョンを切り替える

* Rubyをソースからビルドして使いたい。
	+ tarball のsha1sumを確認しインストールしたいなど。
* Rubyのバージョンを複数から切り替えて使用したい。
* システムワイドな Ruby を使用したい。




## Demo


## VS. 

## Requirement

Rubyのインストール先は、

	/opt/ruby-2.2.3

などが前提となっています。
ビルド時に、インストール先を指定するときは、

	./configure --prefix=/opt/ruby-2.2.3
	make
	sudo make install

などとします。

## Usage

	alt-ruby --help

## Install

	git clone https://github.com/yakisobakintoki/alt-ruby.git
	cd alt-ruby
	sudo bash install.sh

## Uninstall

	sudo bash uninstall.sh

## Contribution

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[yakisobakintoki](https://github.com/yakisobakintoki)

