'use client';

import { useState } from 'react';
import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001';

export default function CodeReviewerPage() {
  const [code, setCode] = useState('');
  const [language, setLanguage] = useState('javascript');
  const [mode, setMode] = useState<'review' | 'explain'>('review');
  const [audience, setAudience] = useState('beginner');
  const [result, setResult] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async () => {
    if (!code.trim()) {
      setError('Please enter some code to analyze');
      return;
    }

    setLoading(true);
    setError('');
    setResult('');

    try {
      const endpoint = mode === 'review' ? 'review' : 'explain';
      const payload = mode === 'review'
        ? { code, language }
        : { code, language, audience };

      const response = await axios.post(
        `${API_URL}/api/prototypes/code-reviewer/${endpoint}`,
        payload
      );

      if (response.data.success) {
        setResult(mode === 'review' ? response.data.review : response.data.explanation);
      } else {
        setError('Failed to process code');
      }
    } catch (err: any) {
      console.error('Error:', err);
      setError(err.response?.data?.error || 'An error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const exampleCode = {
    javascript: `function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}`,
    python: `def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)`,
    typescript: `interface User {
  id: number;
  name: string;
}

async function fetchUser(id: number): Promise<User> {
  const response = await fetch(\`/api/users/\${id}\`);
  return response.json();
}`,
    java: `public class BinarySearch {
    public static int search(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (arr[mid] == target) return mid;
            if (arr[mid] < target) left = mid + 1;
            else right = mid - 1;
        }
        return -1;
    }
}`
  };

  const loadExample = () => {
    setCode(exampleCode[language as keyof typeof exampleCode] || exampleCode.javascript);
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Header */}
      <div className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
        <div className="max-w-7xl mx-auto px-4 py-6">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            🔍 AI Code Reviewer
          </h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">
            Get instant AI-powered code reviews and explanations
          </p>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Input Panel */}
          <div className="space-y-4">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                Your Code
              </h2>

              {/* Mode Selection */}
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Mode
                </label>
                <div className="flex gap-4">
                  <button
                    onClick={() => setMode('review')}
                    className={`flex-1 px-4 py-2 rounded-md font-medium transition-colors ${
                      mode === 'review'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
                    }`}
                  >
                    Review Code
                  </button>
                  <button
                    onClick={() => setMode('explain')}
                    className={`flex-1 px-4 py-2 rounded-md font-medium transition-colors ${
                      mode === 'explain'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-200 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
                    }`}
                  >
                    Explain Code
                  </button>
                </div>
              </div>

              {/* Language Selection */}
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Programming Language
                </label>
                <select
                  value={language}
                  onChange={(e) => setLanguage(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value="javascript">JavaScript</option>
                  <option value="typescript">TypeScript</option>
                  <option value="python">Python</option>
                  <option value="java">Java</option>
                  <option value="cpp">C++</option>
                  <option value="go">Go</option>
                  <option value="rust">Rust</option>
                </select>
              </div>

              {/* Audience Selection (only for explain mode) */}
              {mode === 'explain' && (
                <div className="mb-4">
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Explanation Level
                  </label>
                  <select
                    value={audience}
                    onChange={(e) => setAudience(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  >
                    <option value="beginner">Beginner - Simple terms</option>
                    <option value="intermediate">Intermediate - Moderate detail</option>
                    <option value="expert">Expert - Technical detail</option>
                  </select>
                </div>
              )}

              {/* Code Input */}
              <div className="mb-4">
                <div className="flex justify-between items-center mb-2">
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                    Code
                  </label>
                  <button
                    onClick={loadExample}
                    className="text-sm text-blue-600 hover:text-blue-700 dark:text-blue-400"
                  >
                    Load Example
                  </button>
                </div>
                <textarea
                  value={code}
                  onChange={(e) => setCode(e.target.value)}
                  rows={15}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md font-mono text-sm dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  placeholder="Paste your code here..."
                />
              </div>

              {/* Submit Button */}
              <button
                onClick={handleSubmit}
                disabled={loading || !code.trim()}
                className="w-full px-4 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed font-medium transition-colors"
              >
                {loading ? (
                  <span className="flex items-center justify-center">
                    <svg className="animate-spin h-5 w-5 mr-3" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                    </svg>
                    Processing...
                  </span>
                ) : (
                  mode === 'review' ? '🔍 Review Code' : '📖 Explain Code'
                )}
              </button>

              {/* Error Display */}
              {error && (
                <div className="mt-4 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-md">
                  <p className="text-sm text-red-800 dark:text-red-200">{error}</p>
                </div>
              )}
            </div>
          </div>

          {/* Results Panel */}
          <div className="space-y-4">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                {mode === 'review' ? '📋 Review Results' : '💡 Explanation'}
              </h2>

              {!result && !loading && (
                <div className="text-center py-12">
                  <div className="text-6xl mb-4">
                    {mode === 'review' ? '🔍' : '📖'}
                  </div>
                  <p className="text-gray-500 dark:text-gray-400">
                    {mode === 'review'
                      ? 'Enter your code and click "Review Code" to get AI-powered feedback'
                      : 'Enter your code and click "Explain Code" to get a detailed explanation'}
                  </p>
                </div>
              )}

              {result && (
                <div className="prose dark:prose-invert max-w-none">
                  <div className="bg-gray-50 dark:bg-gray-900 p-4 rounded-md">
                    <pre className="whitespace-pre-wrap text-sm text-gray-800 dark:text-gray-200 font-sans">
                      {result}
                    </pre>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Tips */}
        <div className="mt-8 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-6">
          <h3 className="text-lg font-semibold text-blue-900 dark:text-blue-100 mb-3">
            💡 Tips for Best Results
          </h3>
          <ul className="space-y-2 text-blue-800 dark:text-blue-200">
            <li>• Include complete, functional code snippets for better analysis</li>
            <li>• Use "Review Code" to find bugs, performance issues, and best practices</li>
            <li>• Use "Explain Code" to understand how code works at different expertise levels</li>
            <li>• Try different languages and complexity levels</li>
            <li>• The AI considers security, performance, and maintainability in reviews</li>
          </ul>
        </div>
      </div>
    </div>
  );
}
