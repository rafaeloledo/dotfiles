import { App } from "astal/gtk4"
import VolumePopup from "./widget/VolumePopup"

const css = `
@import url("${SRC}/style.css");
`

App.start({
    instanceName: "ags",
    css,
    main: VolumePopup,
})
