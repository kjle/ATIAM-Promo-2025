# How to write a good readme

This is your readme, which will the text that is displayed when someone lands on your repository. It should at least contain : 
- A short description of your project
- The documentation for installing any dependencies and running the main scripts (training, evaluation etc...)
- A link to the Github page where you hosted your most promising results

When using the Markdown format, you format text in many different ways. For instance, this a way of formatting text to indicate it should be run as a shell script:

To train train your own model, please run 
```bash
python main.py --data_path path/to/dataset --gpu 0 --run_name path/to/store/logs_and_checkpoints
```

Check [the documentation](https://www.markdownguide.org/basic-syntax/) if you need any help.