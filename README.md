# modules

Nextflow modules used in SAGC Nextflow pipelines.

## Coding guidelines

These guidelines were adapted from [UMCUGenetics](https://github.com/UMCUGenetics/NextflowModules/tree/3890843e528a14ada068294c21df731db7126c21).

See utils/template.nf for a process template which uses the following guidelines.

* Use the Tool/version/Command.nf folder structure of this repository.
* Use the original tool version numbering
* Use CamelCase for tool, command and process names
* Use lowercase with words separated by underscores for params, inputs, outputs and scripts.
* Use 4 spaces per indentation level.
* All input and output identifiers should reflect their conceptual identity. Use informative names like unaligned_sequences, reference_genome, phylogeny, or aligned_sequences instead of foo_input, foo_file, result, input, output, and so forth.
* Define two labels for each process, containing toolname, version and command separated by an underscore.
    * BWA_0.7.17
    * BWA_0.7.17_MEM
* Define a tag to each process, containing toolname, command, sample_id and/or rg_id.
    * {"BWA MEM ${sample_id} - ${rg_id}"}
* Add 'set -euo pipefail' to each process.
    * shell = `['/bin/bash', '-euo', 'pipefail']`
* Do not define any runtime settings like cpus, memory and time.
* Set process parameters on include:
    * include process from 'path/to/process.nf' params(optional: '')
* Use separate process input channels as much as possible. Use tuples for linked inputs only.

```
input:
    val(analysis_id)
    tuple(sample_id, path(bam), path(bai))
```

* Define named process output channels. This ensures that outputs can be referenced in external scope by their respective names. Indicate whether an output channel is optional.

```
output:
    path("my_file.txt", emit: my_file)
    path("my_optional_file.txt",  optional: my_optional_file, emit: my_optional_file)
```

* Use params for resource files, for example genome.fasta, database.vcf.
