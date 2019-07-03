<anaframe>
	<webview src="about:blank" border="0"></webview>

	<style>
		anaframe {
			display: block;
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		anaframe > webview {
			width: 100%;
			height: 100%;
			border: 0;
		}
	</style>
	<script>
		const {shell} = require('electron')
		export default {
			onBeforeMount() {
				this._username = ''
				this.frame = null
				this.addon = this.props.addon
				this.makeAccessible()
			},

			onMounted() {
				const self = this
				this.frame = this.root.querySelector('webview')
				this.frame.addEventListener('did-finish-load', () => { self.pagechange() })
				if(this._username.length > 0) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/channel-analytics')
				}
				this.frame.addEventListener('new-window', (e) => {
					if(e.disposition != 'save-to-disk') {
						shell.openExternal(e.url)
					}
				})
				this.frame.addEventListener('did-start-loading', (e) => {
					Tool.ui.startLoading(this.addon)
				})
				this.frame.addEventListener('did-stop-loading', (e) => {
					Tool.ui.stopLoading(this.addon)
				})
			},

			open_stats(username) {
				this._username = username
				if(this.frame !== null) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/channel-analytics')
				}
			},

			pagechange() {
				let location = this.frame.getURL()

				if(location.length <= 0) return
				if(!location.startsWith('https://passport.twitch.tv/') && !location.startsWith('https://www.twitch.tv/' + this._username.toLowerCase() + '/dashboard/channel-analytics')) {
					this.frame.loadURL('https://www.twitch.tv/' + this._username + '/dashboard/channel-analytics')
				}
				
				let webcontent = this.frame.getWebContents()
				webcontent.insertCSS('\
						.top-nav,\
						.dashboard-side-nav,\
						.ca-welcome-modal,\
						.tw-tooltip-wrapper\
						{ display: none !important; }\
				')
				webcontent.executeJavaScript('\
					document.querySelector("html").classList.add("tw-root--theme-dark");\
					setTimeout(() => { document.querySelectorAll("a.button")[0].style.display="none"; }, 2000);\
				')
			}
		}
	</script>
</anaframe>