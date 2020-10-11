#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 29 18:00:19 2017

@author: Carl
"""
import sklearn
import pickle # backup
import re
import numpy as np
from pandas import Series
from pandas import DataFrame
import codecs
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import SGDClassifier
from sklearn.pipeline import Pipeline
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
import MeCab
from sklearn import svm


if "i" in "Jail": #load variable when it's not in memory
    f = open('factiva_text.pckl', 'rb')
    factiva_text=pickle.load(f)
    f.close()

def core_text(x):
    '''
    Input: Factiva content (LIST of paragraphs)
    Output: A processed string ready for tokenization, [should we remove punctuation?]
    '''
    if len(x[-2]) < 40: # less than 40 = not a real paragraph
        x[-2] == ""     # just make it an empty str, list are mutable!
    x = x[:4]
   #x = x[:-1]          # drop the last paragraph (always the copyright text)
    x = "".join(x)      # join all paragraphs (items in list) together with ""
    x = re.sub("【.*?】", "", x) # clean out all 【】 and things whtin
    x = re.sub("\n", "", x)    # clearn linebreaks in the form of Py str literal
    x = re.sub("\u3000", "", x) # clean Japanese full-width space
    x = re.sub("■", "", x) # clean symobols that is often used to start an article
    x = re.sub("●", "", x) ### 
    x = re.sub("◆", "", x) # clean symobols that is often used to start an article
    x = re.sub("◇", "", x) # clean symobols that is often used to start an article
    x = re.sub(" ", "", x) # they sometimes use English space to indent too...
    x = re.sub("\(.*?\)", "", x) # clean all the half-width parentheses and within
    x = re.sub("\（.*?\）", "", x) # clean all the full-width 括弧 and within
    # need to check the effects of the lines below closely
    # somehow they're not doing the work, leaving tails of 產經 and Yomiuri
    # while seemingly cut of many newstexts
    x = re.sub("。([a-zA-Z0-9.,＋].*)$", "。", x)
    x = re.sub("。([a-zA-Z0-9.,＋].*)$", "。", x)
    '''
    x = re.sub("。[a-zA-Z0-9]+$", "", x)
    x = re.sub("写真＝.*$", "", x)
    x = re.sub("＝.*$", "", x)
    '''
    return x # return a string

def core_cat(x):
    '''
    Input: Factiva title (typically list of just one item)
    Output: A processed string ready for tokenization (simpler than the content func)
    '''
    x = "".join(x)
    x = re.sub("【.*?】", "", x)
    x = re.sub("\n", "", x)
    x = re.sub("\u3000", "", x)
    x = re.sub("■", "", x)
    x = re.sub("◆", "", x)
    x = re.sub("◇", "", x)
    x = re.sub(" ", "", x)
    x = re.sub("\(.*?\)", "", x)
    x = re.sub("\（.*?\）", "", x)
    return x

def wakati(text):
    tagger = MeCab.Tagger('-d/usr/local/lib/mecab/dic/mecab-ipadic-neologd')
    tagger.parse('') # <= 空文字列をparseする 
                     # took 2hrs before http://qiita.com/piruty_joy/items/ce218090eae53b775b79
    node = tagger.parseToNode(text)
    word_list = []
    while node:
        pos = node.feature.split(",")[0]
        if pos in ["名詞", "動詞", "形容詞"]:
            lemma = node.feature.split(",")[6]
            if lemma == u"*":
                lemma = node.surface
            word_list.append(lemma)
        node = node.next
    return u" ".join(word_list[:])

###########################
factiva_text['cat']=factiva_text['cat'].apply(core_cat)
factiva_text= factiva_text[factiva_text['title'].str.contains("【") == False] # get rif of 產經抄、主張
factiva_text['content']=factiva_text['content'].apply(core_text)
factiva= factiva_text[['date', 'newsid','title','content']]
factiva = factiva.sort_values('date')

############################## Cosine similarity for Content
takeshimaday = factiva[factiva['content'].str.contains("竹島の日")]
takeshimaday['wakati'] = takeshimaday['content'].apply(wakati)
count_vectorizer = CountVectorizer()
############################## Cosine similarity
consine_T= count_vectorizer.fit_transform(takeshimaday['wakati'])
cosine_sim = sklearn.metrics.pairwise.cosine_similarity(consine_T)

takeshimaday.to_csv("takeshima_articles.csv", sep='@', encoding="utf-8")
np.savetxt("takeshima_cosine.csv", cosine_sim, delimiter=",")

############################## Cosine similarity for Title
takeshimaday['wakati'] = takeshimaday['title'].apply(wakati)
count_vectorizer = CountVectorizer()
############################## Cosine similarity
consine_T= count_vectorizer.fit_transform(takeshimaday['wakati'])
cosine_sim = sklearn.metrics.pairwise.cosine_similarity(consine_T)

np.savetxt("takeshima_cosine_title.csv", cosine_sim, delimiter=",")




############################## Takeshima (NOT DAY)

############################## Cosine similarity for Content
takeshima = factiva[factiva['content'].str.contains("竹島")]
takeshima['wakati'] = takeshima['content'].apply(wakati)
count_vectorizer = CountVectorizer()
############################## Cosine similarity
consine_T= count_vectorizer.fit_transform(takeshima['wakati'])
cosine_sim = sklearn.metrics.pairwise.cosine_similarity(consine_T)

takeshima.to_csv("takeshima_full_articles.csv", sep='@', encoding="utf-8")
np.savetxt("takeshima_full_cosine.csv", cosine_sim, delimiter=",")

############################## Cosine similarity for Title
takeshima['wakati'] = takeshima['title'].apply(wakati)
count_vectorizer = CountVectorizer()
############################## Cosine similarity
consine_T= count_vectorizer.fit_transform(takeshima['wakati'])
cosine_sim = sklearn.metrics.pairwise.cosine_similarity(consine_T)

np.savetxt("takeshima_full_cosine_title.csv", cosine_sim, delimiter=",")




