```python
import pandas as pd # Importing the pandas library for data manipulation and analysis.
import numpy as np # Importing the numpy library for numerical operations and computations.
import os # Importing the os library for interacting with the operating system.
import glob # Importing the glob library for file path matching and retrieval.
```

## Neurosynth Database Query

This Jupyter Notebook Python script is used to automatically access the NeurosynthDecoder via Nimare for standard Bayesian reverse inference decoding and systems-level decoding, as described in the main section of the publication.

To use the script for a specific decoding strategy, make sure to place the correct volumetric images (e.g., volumetric images produced by Systems-level decoding Code 1 "Code1_create_nii_IPS_systems-level_decoding") in the corresponding Users/../Data working directory. Additionally, Jupyter Notebook and the required Python packages must be installed.

**neurosynth_nimare_with_abstracts.pkl.gz** can be downloaded vie NiMARE (https://nimare.readthedocs.io/en/0.0.3/auto_examples/01_datasets/download_neurosynth.html)

For more information on the NeurosynthDecoder and NiMARE, visit the following link:

[https://nimare.readthedocs.io/en/latest/auto_examples/04_decoding/01_plot_discrete_decoders.html#sphx-glr-auto-examples-04-decoding-01-plot-discrete-decoders-py](https://nimare.readthedocs.io/en/latest/auto_examples/04_decoding/01_plot_discrete_decoders.html#sphx-glr-auto-examples-04-decoding-01-plot-discrete-decoders-py)



```python

# create path to dataset stored in "Data" folder in your working directory
out_dir = os.path.abspath("Data/neurosynth_nimare_with_abstracts.pkl.gz")

# load dataset with abstracts
dset = nimare.dataset.Dataset.load(os.path.join(out_dir))

def neurosnyth():
    """
    This function performs a database query using the NeurosynthDecoder in Nimare.
    It creates an image-like mask from .nii files and retrieves studies with voxels in the mask.
    The .nii image is then decoded using the Neurosynth method, and the decoded results are saved to CSV files.
    """
    for file in os.listdir("Data"):  # Retrieve files from folder where you stored your volumetric images
        if file.endswith(".nii"):  # Enter prefix + suffix of your files here
            cluster_relative_path = os.path.join("Data", file)
            cluster_absolute_path = os.path.abspath(cluster_relative_path)
            
            # Get studies with voxels in the mask
            ids = dset.get_studies_by_mask(cluster_absolute_path)
            
            # Decode .nii image using the Neurosynth method
            # For details of statistical thresholds, check: https://nimare.readthedocs.io/en/latest/generated/nimare.decode.discrete.neurosynth_decode.html#nimare.decode.discrete.neurosynth_decode
            decoder = discrete.NeurosynthDecoder(frequency_threshold=0.001, prior=0.5, u=0.05, correction='fdr_bh')
            decoder.fit(dset)
            decoded_df = decoder.transform(ids=ids)
            
            decoded_df.sort_values(by="probReverse", ascending=False).head()
            # Sort by ProbReverse in descending order; for top 30 (e.g.) as done in the systems-level decoding, type head(30).
            
            # Save files to CSV
            base_filename = os.path.splitext(file)[0]
            decoded_filename2 = base_filename + '.csv'
            path_for_decoded_file_2 = 'Data/Results/' + decoded_filename2  # Set the directory where result files should be stored
            decoded_df.sort_values(by="probReverse", ascending=False).to_csv(path_for_decoded_file_2)


neurosnyth()

```

# Meta-Analytic Decoding

The following functions are used to:
1. Retrieve the result files of the database query.
2. Search the results for search terms (i.e., 'Alzheimer', 'Alzheimer's disease', 'mild cognitive', 'MCI', 'cognitive impairment') and generate a table with all region-term associations, their p-values, reverse probabilities, and Bayes factors
3. Search the results for search terms (i.e., 'Alzheimer', 'Alzheimer's disease', 'mild cognitive', 'MCI', 'cognitive impairment') and generate a table with all **significant** region-term associations, their p-values, reverse probabilities, and Bayes factors

For further details, we would like to refer to the original publication and the following published articles:

- Boeken, O. J., Cieslik, E. C., Langner, R., & Markett, S. (2022). Characterizing functional modules in the human thalamus: Coactivation-based parcellation and systems-level functional decoding. Brain Structure and Function. [DOI: 10.1007/s00429-022-02603-w](https://doi.org/10.1007/s00429-022-02603-w)

- Boeken, O. J., & Markett, S. (2023). Systems-level decoding reveals the cognitive and behavioral profile of the human intraparietal sulcus. Frontiers in Neuroimaging, 1, 1074674. [DOI: 10.3389/fnimg.2022.1074674](https://doi.org/10.3389/fnimg.2022.1074674)





```python


def get_decoding_csv_files(path):
    """
    A function that loads CSV files from a specified directory and returns the keys and data stored in a dictionary.
    
    Args:
        path (str): The directory path where the CSV files are located.
    
    Returns:
        tuple: A tuple containing two elements:
            - files_dict_keys (list): A list of keys representing the filenames of the loaded CSV files.
            - files_dict (dict): A dictionary where the keys are filenames and the values are pandas DataFrames
                                containing the data from the corresponding CSV files.
    """
    
    # Set path to the results of the Neurosynth database query
    path ='' #enter path here within quotation marks
    
    all_files = glob.glob(path + "/*.csv")  # Get all CSV files in the working directory defined above
    all_files.sort()  # Python reads files in random order, so we need to sort them
    
    # Store data in empty dictionary files_dict
    files_dict = {}
    for file in all_files:
        files_dict[file] = pd.read_csv(file)  # (keys == filenames)
        
    files_dict_keys = list(files_dict.keys()) 
    
    return files_dict_keys, files_dict

```


```python
%%capture
#no need to display output in every function call down below.

def check_keywords():
    

    """The function checks for keywords (e.g., Alzheimer) in the CSV files obtained from the database query. 
    It then creates separate CSV files for each region of the Desikan Kiliany atlas. 
    These files contain information about the Neurosynth term, the p-values, 
    whether the results are statistically significant for multiple comparisons below 0.05, 
    the reverse probability values, and the Bayes factors 
    (calculated as probReverse divided by (1 - probReverse), 
    as described in Poldrack, 2007)."
    """
     
    #Set path to Neurosynth results
    path = '' #enter path here within quotation marks
    
    #call function and store returned variables in keys(filenames) and dfs(datasets)
    [keys,dfs] = get_decoding_csv_files(path)
    
    #Define keywords here:
    keywords = ['alzheimer', 'alzheimer disease', 'mild cognitive', 'mci', 'cognitive impairment']
    
    #define empty dictionary to store the data in, before entering the loop                                
    data_dict = {}
                                                                
    for i in range(len(keys)):#loop through all neurosynth files
        
        #store data of file i in pandas dataframe temp_df                                
        temp_df = dfs[keys[i]] 
        
                                        
        #the filename contains the region label. Thus replace all unneccessary info to retrieve the name:                 
        region_name = keys[i].replace(path + "/", "")
        region_name = region_name.replace(".csv","")
        
      
        #before entering the next loop add keys to the predefined empty data_dict 
        #Note: the keys will be used as coloumn headers in the output csv files!
        data_dict['terms'] = {}
        terms_list = [] #create empty list, will be used to store the temporary date in.
        data_dict['pReverse'] = {}
        pval_list = []
        data_dict['signifcant<0.05'] = {}
        sign_list = []
        data_dict['probReverse'] = {}
        probR_list = []
        data_dict['Bayes']= {}
        bayes_list = []
        
        
        for j in range(len(keywords)): # loop through keywords
            
            #search for keywords in neurosynth file stored in temp_df
            
            #clean the terms from the database query, the we can search for an exact match with the keywords:
            terms = temp_df['Term'].str.replace("Neurosynth_TFIDF__","", regex= True) #in dataframe temp_df acces coloumn ['Term']
            
            #get row index where keyword matches the neurosynth term with numpy function np.where()
            index = np.where(terms == keywords[j])
            
            #use index to get data of:
            term = list(temp_df.loc[index,'Term']) #Neurosynth Term
            p_val = list(temp_df.loc[index,'pReverse']) #p value
            probReverse = list(temp_df.loc[index,'probReverse']) #reverse probability
            sign = list(temp_df.loc[index,'pReverse']<0.05) #info whether p val is sign. or not
            bayes = list(temp_df.loc[index,'probReverse']/(1-temp_df.loc[index,'probReverse'])) # calculated Bayes factor
            
                                        
            terms_list.append(term) #append data to predefined empty list
            pval_list.append(p_val)
            sign_list.append(sign)
            probR_list.append(probReverse)
            bayes_list.append(bayes)
            
            
        data_dict['terms'] = terms_list #store list in dictionary
        data_dict['pReverse'] = pval_list
        data_dict['signifcant<0.05'] = sign_list
        data_dict['probReverse'] = probR_list
        data_dict['Bayes'] = bayes_list
    
    
        #create filename for output:    
        BaseName = region_name + '.csv'
        
        #transform dictionary to back to dataframe
        a = pd.DataFrame.from_dict(data_dict)
        
        #write data to harddrive
        a.to_csv(BaseName)
    
    
    
    

```


```python
#call function
check_keywords() 
```


```python

def check_keywords_sign():
    

    """This function checks for keywords (e.g., Alzheimer) in the CSV files obtained from a database query. 
    It then creates separate CSV files for each region of the Desikan Kiliany atlas, 
    containing information about the Neurosynth term, p-values, 
    whether the results are statistically significant for multiple comparisons below 0.05, 
    reverse probability values, and Bayes factors (calculated as probReverse/(1-probReverse) 
    following Poldrack, 2007).

    This function enhances the previous version by only writing data to CSV files if the terms are 
    statistically significant. 
    This modification simplifies the process of identifying and analyzing regions with significant terms
    """
    
     
    #Set path to Neurosynth results
    path = '' #enter path here within quotation marks
    
    #call function and store returned variables in keys(filenames) and dfs(datasets)
    [keys,dfs] = get_decoding_csv_files(path)
    
    #Define keywords here:
    keywords = ['alzheimer', 'alzheimer disease', 'mild cognitive', 'mci', 'cognitive impairment']
    
    
    #define empty dictionary to store the data in, before entering the loop                                
    data_dict = {}
                                        
                                        
    for i in range(len(keys)):#loop through all neurosynth files
        
        #store data of file i in pandas dataframe temp_df                                
        temp_df = dfs[keys[i]] 
                           
                                        
        #the filename contains the region label. Thus replace all unneccessary info to retrieve the name:                 
        region_name = keys[i].replace(path + "/", "")
        region_name = region_name.replace(".csv","")
    
      
        #before entering the next loop add keys to the predefined empty data_dict 
        #Note: the keys will be used as coloumn headers in the output csv files!
        data_dict['terms'] = {}
        terms_list = [] #create empty list, will be used to store the temporary date in.
        data_dict['pReverse'] = {}
        pval_list = []
        data_dict['signifcant<0.05'] = {}
        sign_list = []
        data_dict['probReverse'] = {}
        probR_list = []
        data_dict['Bayes']= {}
        bayes_list = []
        
        
        for j in range(len(keywords)): # loop through keywords
            
            #search for keywords in neurosynth file stored in temp_df
            
            #clean the terms from the database query, the we can search for an exact match with the keywords:
            terms = temp_df['Term'].str.replace("Neurosynth_TFIDF__","", regex= True) #in dataframe temp_df acces coloumn ['Term']
            
            #get row index where keyword matches the neurosynth term with numpy function np.where()
            index = np.where(terms == keywords[j]) 
            
            
            #only if p-reverse is below 0.05 fill the the dictionary
            if float(temp_df.loc[index,'pReverse'])<0.05:
                
                
                #use index to get data 
                term = list(temp_df.loc[index,'Term']) #Neurosynth Term
                p_val = list(temp_df.loc[index,'pReverse']) #p value
                probReverse = list(temp_df.loc[index,'probReverse']) #reverse probability
                sign = list(temp_df.loc[index,'pReverse']<0.05) #info whether p val is sign. or not
                bayes = list(temp_df.loc[index,'probReverse']/(1-temp_df.loc[index,'probReverse'])) # calculated Bayes factor
            
                                        
                terms_list.append(term) #append data to predefined empty list
                pval_list.append(p_val)
                sign_list.append(sign)
                probR_list.append(probReverse)
                bayes_list.append(bayes)
            
            
                data_dict['terms'] = terms_list #store list in dictionary
                data_dict['pReverse'] = pval_list
                data_dict['signifcant<0.05'] = sign_list
                data_dict['probReverse'] = probR_list
                data_dict['Bayes'] = bayes_list
            
            else:

                pass # do noting
                
    
        #now check if the loop above entered any values (dicts have key-value pairs) to the keys
        #if region has not any significant term, the dictionary has no values 
        if not any (data_dict.values()):
            print(f'is empty, for {region_name}')
        else:
            #create filename for output:    
            BaseName = region_name + '_sign.csv'
        
            #transform dictionary to back to dataframe
            a = pd.DataFrame.from_dict(data_dict)
        
            #write data to harddrive
            a.to_csv(BaseName)
            
```


```python
#call function
check_keywords_sign()
```
