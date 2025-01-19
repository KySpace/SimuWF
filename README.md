# SimuWF
A GPE simulation program of a single wavefunction with custom potential, dispersion, interaction, and more!

### Install
clone the repository with 
```git clone https://github.gatech.edu/kwang407/SimuWF.git```
initialize and clone the submodules
```git submodule init```
```git submodule update```

It is also suggested to switch all the submodule HEAD to the corresponding branches rather than commits.

### Configuration
Use 
```matlab
> loadlib
``` 
in Matlab console to include proper libraries.
Add a `config_local.json` file at the root to specify where you save the data. 
```json
{
    "testrootdir" : {
        "normal" : "<normal path>",
        "backup" : "<backup path>"
    }
}
```

Configure your test with a `<ioconfig>.yaml`. Configure your parameters with a `<dictschm>.yaml`. You can find samples are in the `Test` folder with similar names. You can refer to the `TestRunner`'s library to see how these two files work.

Configure which `<ioconfig>` to use, and the details of the run (start/end index, debug mode etc.) from `config_run.json`. Usually, the `ioconfig_convrule_filepath` can be chosen to be `[TestRunner]/convert/ioconfig.convrule.yaml`

Run the test by using the `TestRunner` library functions that will run from the configuration files:
```matlab
> autorun
```


