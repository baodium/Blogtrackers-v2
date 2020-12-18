package util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javafx.util.Pair;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.util.TreeMap;

import util.Stopwords;
import util.TopicModelling.Documents.Document;

public class TopicModelling {

	public class modelparameters {
		float alpha = 0.5f; //usual value is 50 / K
		float beta = 0.1f;//usual value is 0.1
		int topicNum = 10;
		int iteration = 100;
		int saveStep = 10;
		int beginSaveIters = 80;
	}
	
	private Documents docSet;
	private LdaModel model;
	
	public TopicModelling(ArrayList<BlogPost> blogs, int n) {
		modelparameters ldaparameters = new modelparameters();
		ldaparameters.topicNum = n;
		docSet = new Documents();
		docSet.readDocs(blogs);
		model = new LdaModel(ldaparameters);
		run();
	}
	
	// Word Frequency - Phi (Document x Terms matrix)
	public double[][] getPhi() {
		return model.phi;
	}
	
	// Topic Frequency Matrix - Theta (Document x Topic matrix)
	public double[][] getTheta() {
		return model.theta;
	}
	
	public ArrayList<Document> getDocuments() {
		return docSet.docs;
	}
	
	public void assignTheta() {
		model.assignTheta(docSet);
	}
	
	public String getTAssign() {
		return model.getTAssign();
	}
	
	public Map<Integer, ArrayList<Pair<String, Double>>> getTopics() {
		return getTopics(10);
	}
	
	// Topic words - numWords is the number of words per topic
	public Map<Integer, ArrayList<Pair<String, Double>>> getTopics(int numWords) {
		return model.getTopicWords(docSet, numWords);
	}
	
	public void run() {
		
		// 1 Initialize model
		model.initializeModel(docSet);
		
		// 2 Learning
		model.inferenceModel(docSet);
		
		// 3 Final model ready
		model.assignTheta(docSet);
	}

	public static class BlogPost {
		String id;
		String title;
		String post;
		String date;
		String blogger;
		String location;
		String numComments;
		
		public BlogPost(String bi, String bt, String bp, String bd, String bg, String lc, String bc) {
			id = bi;
			title = bt;
			post = bp;
			date = bd;
			blogger = bg;
			location = lc;
			numComments = bc;
		}
	}
	
	public class LdaModel {
		
		int [][] doc;//word index array
		double [][] phi;//Parameters for topic-word distribution K*V
		double [][] theta;//Parameters for doc-topic distribution M*K
		int V, K, M;//vocabulary size, topic number, document number
		int [][] z;//topic label array
		float alpha; //doc-topic dirichlet prior parameter 
		float beta; //topic-word dirichlet prior parameter
		int [][] nmk;//given document m, count times of topic k. M*K
		int [][] nkt;//given topic k, count times of term t. K*V
		int [] nmkSum;//Sum for each row in nmk
		int [] nktSum;//Sum for each row in nkt
		int iterations;//Times of iterations
		int saveStep;//The number of iterations between two saving
		int beginSaveIters;//Begin save model at this iteration
		
		public LdaModel(TopicModelling.modelparameters modelparam) {
			// TODO Auto-generated constructor stub
			alpha = modelparam.alpha;
			beta = modelparam.beta;
			iterations = modelparam.iteration;
			K = modelparam.topicNum;
			saveStep = modelparam.saveStep;
			beginSaveIters = modelparam.beginSaveIters;
		}

		public void initializeModel(Documents docSet) {
			// TODO Auto-generated method stub
			M = docSet.docs.size();
			V = docSet.termToIndexMap.size();
			nmk = new int [M][K];
			nkt = new int[K][V];
			nmkSum = new int[M];
			nktSum = new int[K];
			phi = new double[K][V];
			theta = new double[M][K];
			
			//initialize documents index array
			doc = new int[M][];
			for(int m = 0; m < M; m++){
				//Notice the limit of memory
				int N = docSet.docs.get(m).docWords.length;
				doc[m] = new int[N];
				for(int n = 0; n < N; n++){
					doc[m][n] = docSet.docs.get(m).docWords[n];
				}
			}
			
			//initialize topic lable z for each word
			z = new int[M][];
			for(int m = 0; m < M; m++){
				int N = docSet.docs.get(m).docWords.length;
				z[m] = new int[N];
				for(int n = 0; n < N; n++){
					int initTopic = (int)(Math.random() * K);// From 0 to K - 1
					z[m][n] = initTopic;
					//number of words in doc m assigned to topic initTopic add 1
					nmk[m][initTopic]++;
					//number of terms doc[m][n] assigned to topic initTopic add 1
					nkt[initTopic][doc[m][n]]++;
					// total number of words assigned to topic initTopic add 1
					nktSum[initTopic]++;
				}
				 // total number of words in document m is N
				nmkSum[m] = N;
			}
		}

		public void inferenceModel(Documents docSet) {
			// TODO Auto-generated method stub
			if(iterations < saveStep + beginSaveIters){
				System.err.println("Error: the number of iterations should be larger than " + (saveStep + beginSaveIters));
				System.exit(0);
			}
			for(int i = 0; i < iterations; i++){
				if((i >= beginSaveIters) && (((i - beginSaveIters) % saveStep) == 0)){
					//Update parameters
					updateEstimatedParameters();
				}
				
				//Use Gibbs Sampling to update z[][]
				for(int m = 0; m < M; m++){
					int N = docSet.docs.get(m).docWords.length;
					for(int n = 0; n < N; n++){
						// Sample from p(z_i|z_-i, w)
						int newTopic = sampleTopicZ(m, n);
						z[m][n] = newTopic;
					}
				}
			}
		}
		
		private void updateEstimatedParameters() {
			// TODO Auto-generated method stub
			for(int k = 0; k < K; k++){
				for(int t = 0; t < V; t++){
					phi[k][t] = (nkt[k][t] + beta) / (nktSum[k] + V * beta);
				}
			}
			
			for(int m = 0; m < M; m++){
				for(int k = 0; k < K; k++){
					theta[m][k] = (nmk[m][k] + alpha) / (nmkSum[m] + K * alpha);
				}
			}
		}

		private int sampleTopicZ(int m, int n) {
			// TODO Auto-generated method stub
			// Sample from p(z_i|z_-i, w) using Gibbs upde rule
			
			//Remove topic label for w_{m,n}
			int oldTopic = z[m][n];
			nmk[m][oldTopic]--;
			nkt[oldTopic][doc[m][n]]--;
			nmkSum[m]--;
			nktSum[oldTopic]--;
			
			//Compute p(z_i = k|z_-i, w)
			double [] p = new double[K];
			for(int k = 0; k < K; k++){
				p[k] = (nkt[k][doc[m][n]] + beta) / (nktSum[k] + V * beta) * (nmk[m][k] + alpha) / (nmkSum[m] + K * alpha);
			}
			
			//Sample a new topic label for w_{m, n} like roulette
			//Compute cumulated probability for p
			for(int k = 1; k < K; k++){
				p[k] += p[k - 1];
			}
			double u = Math.random() * p[K - 1]; //p[] is unnormalised
			int newTopic;
			for(newTopic = 0; newTopic < K; newTopic++){
				if(u < p[newTopic]){
					break;
				}
			}
			
			//Add new topic label for w_{m, n}
			nmk[m][newTopic]++;
			nkt[newTopic][doc[m][n]]++;
			nmkSum[m]++;
			nktSum[newTopic]++;
			return newTopic;
		}

		public String getTAssign() {
			// TODO Auto-generated method stub
			
			//lda.tassign
			String tassign = "";
			for(int m = 0; m < M; m++){
				for(int n = 0; n < doc[m].length; n++){
					tassign += doc[m][n] + ":" + z[m][n] + "\t";
				}
				tassign += "\n";
			}
			return tassign;
		}
		
		public Map<Integer, ArrayList<Pair<String, Double>>> getTopicWords(Documents docSet, int numWords) {
			
			//lda.twords phi[][] K*V
			Map<Integer, ArrayList<Pair<String, Double>>> topic_words = new TreeMap<Integer, ArrayList<Pair<String, Double>>>();
			for(int i = 0; i < K; i++){
				List<Integer> tWordsIndexArray = new ArrayList<Integer>(); 
				for(int j = 0; j < V; j++){
					tWordsIndexArray.add(new Integer(j));
				}
				Collections.sort(tWordsIndexArray, new LdaModel.TwordsComparable(phi[i]));
				ArrayList<Pair<String, Double>> wordList = new ArrayList<Pair<String, Double>>();
				for(int t = 0; t < numWords && t < V; t++){
					wordList.add(new Pair<String, Double>(docSet.indexToTermMap.get(tWordsIndexArray.get(t)), phi[i][tWordsIndexArray.get(t)]));
				}
				topic_words.put(i, wordList);	
			}
			return topic_words;
		}
		
		public void assignTheta(Documents docset) {
			for (int i = 0; i <  docset.docs.size(); i++) {
				docset.docs.get(i).theta = theta[i].clone();
			}
		}
		
		public class TwordsComparable implements Comparator<Integer> {
			
			public double [] sortProb; // Store probability of each word in topic k
			
			public TwordsComparable (double[] sortProb){
				this.sortProb = sortProb;
			}

			@Override
			public int compare(Integer o1, Integer o2) {
				// TODO Auto-generated method stub
				//Sort topic word index according to the probability of each word in topic k
				if(sortProb[o1] > sortProb[o2]) return -1;
				else if(sortProb[o1] < sortProb[o2]) return 1;
				else return 0;
			}
		}
	}	

	/** Class for corpus which consists of M documents */
	public class Documents {
		
		ArrayList<Document> docs; 
		Map<String, Integer> termToIndexMap;
		ArrayList<String> indexToTermMap;
		Map<String,Integer> termCountMap;
		
		public Documents(){
			docs = new ArrayList<Document>();
			termToIndexMap = new HashMap<String, Integer>();
			indexToTermMap = new ArrayList<String>();
			termCountMap = new HashMap<String, Integer>();
		}
		
		public void readDocs(ArrayList<BlogPost> blogposts){
			for(BlogPost blogpost : blogposts){
				Document doc = new Document(blogpost, termToIndexMap, indexToTermMap, termCountMap);
				docs.add(doc);
			}
		}
		
		public class Document {
			public String blog_id;
			public String blog_title;
			public String blog_post;
			public String blog_date;
			public String blog_author;
			public String blog_location;
			public String blog_numComments;
			public double[] theta;
			int[] docWords;
			
			public void tokenizeAndLowerCase(String line, ArrayList<String> tokens) {
				// TODO Auto-generated method stub
				StringTokenizer strTok = new StringTokenizer(line);
				while (strTok.hasMoreTokens()) {
					String token = strTok.nextToken();
					token = token.replaceAll("\\p{Punct}", "");
					tokens.add(token.toLowerCase().trim());
				}
			}
			
			public Document(BlogPost blogpost, Map<String, Integer> termToIndexMap, ArrayList<String> indexToTermMap, Map<String, Integer> termCountMap){
				blog_id = blogpost.id;
				blog_title = blogpost.title;
				blog_post = blogpost.post;
				blog_date = blogpost.date;
				//blog_author = blogpost.blogger.split("\n")[0];
				blog_author = "Author";
				/*
				System.out.println("Test");
				if (blog_title.contains("Super Bowl LV")) {
					System.out.println(blogpost.blogger);
				}
				else {
					System.out.println(blogpost.blogger);
				}
				*/
				blog_location = blogpost.location;
				blog_numComments = blogpost.numComments;
				//Read file and initialize word index array
				ArrayList<String> words = new ArrayList<String>();
				tokenizeAndLowerCase(blog_post, words);
				//Remove stop words and noise words
				for(int i = 0; i < words.size(); i++){
					if(Stopwords.isStopword(words.get(i)) || isNoiseWord(words.get(i))){
						words.remove(i);
						i--;
					}
				}
				//Transfer word to index
				this.docWords = new int[words.size()];
				for(int i = 0; i < words.size(); i++){
					String word = words.get(i);
					if(!termToIndexMap.containsKey(word)){
						int newIndex = termToIndexMap.size();
						termToIndexMap.put(word, newIndex);
						indexToTermMap.add(word);
						termCountMap.put(word, new Integer(1));
						docWords[i] = newIndex;
					} else {
						docWords[i] = termToIndexMap.get(word);
						termCountMap.put(word, termCountMap.get(word) + 1);
					}
				}
				words.clear();
			}
			
			public boolean isNoiseWord(String string) {
				// TODO Auto-generated method stub
				string = string.toLowerCase().trim();
				Pattern MY_PATTERN = Pattern.compile(".*[a-zA-Z]+.*");
				Matcher m = MY_PATTERN.matcher(string);
				// filter @xxx and URL
				if(string.matches(".*www\\..*") || string.matches(".*\\.com.*") || 
						string.matches(".*http:.*") )
					return true;
				if (!m.matches()) {
					return true;
				} else
					return false;
			}		
		}
	}
}

