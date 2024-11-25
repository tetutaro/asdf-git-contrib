#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/git/git"
TOOL_NAME="git-contrib"
TOOL_TEST="git --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if git-contrib is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' |
		grep -oE '^[0-9]+\.[0-9]+\.[0-9]+$' |
		grep -v -e '^0\.' -e '^1\.'
}

list_all_versions() {
	# Change this function if git-contrib has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/archive/v${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cd "$ASDF_DOWNLOAD_PATH"
		make configure
		./configure --prefix="$install_path"
		make
		make install
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."
		# git-jump
		test -x contrib/git-jump/git-jump || fail "Expected git-jump to be executable."
		cp contrib/git-jump/git-jump "$install_path/bin/."
		# diff-highlight
		cd contrib/diff-highlight
		make
		test -x diff-highlight || fail "Expected diff-highlight to be executable."
		cp diff-highlight "$install_path/bin/."
		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

function log_failure_and_exit() {
	printf "🚨  %s\\n" "${@}"
	exit 1
}

function log_failure() {
	printf "🚨  %s\\n" "${@}"
}

function log_info() {
	printf "%s\\n" "${@}"
}

function log_success() {
	printf "✅  %s\\n" "${@}"
}

function log_warning() {
	printf "⚠️  %s\\n" "${@}"
}

function check_dependencies() {
	local dependencies_file="${1}"
	local failure_type="${2}" # should be "warning" or "failure"
	declare -a missing_dependencies=()

	# loop over file of line separated list of dependencies required by this tool
	while IFS="" read -r p || [ -n "${p}" ]; do
		if [ ! "$(command -v "${p}")" ]; then
			missing_dependencies+=("${p}")
		fi
	done <"${dependencies_file}"

	if [ "${#missing_dependencies[@]}" -ne 0 ]; then
		if [ "${failure_type}" == "warning" ]; then
			log_warning "Missing dependencies! These are hard requirements to install git."
			log_warning "${missing_dependencies[@]}"
			log_info "You should install the listed dependencies before continuing."
		else
			log_failure "Missing dependencies! These are hard requirements to install git."
			log_failure_and_exit "${missing_dependencies[@]}"
		fi
	else
		log_success "All dependencies found on system!"
	fi
}
