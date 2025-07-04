python
def callback(commit, metadata):
    old_email = b"kh2662174@gmail.com"  # أو البريد الإلكتروني المستخدم في Commits
    new_email = b"asalameh02@gmail.com"
    new_name = b"Ahmad Maher"
    
    if commit.author_email == old_email or commit.author_name == old_email:
        commit.author_email = new_email
        commit.author_name = new_name
        
    if commit.committer_email == old_email or commit.committer_name == old_email:
        commit.committer_email = new_email
        commit.committer_name = new_name
        
    return commit